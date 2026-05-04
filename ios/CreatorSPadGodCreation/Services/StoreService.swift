import StoreKit

@Observable
@MainActor
class StoreService {
    private(set) var products: [Product] = []
    private(set) var purchasedProductIDs: Set<String> = []
    private(set) var isLoading: Bool = false

    static let removeAdsID = "com.creatorspad.removeads"
    static let premiumID = "com.creatorspad.premium"

    private var transactionListener: Task<Void, Never>?
    private var isInitialized = false

    var hasRemovedAds: Bool {
        purchasedProductIDs.contains(Self.removeAdsID) || hasPremium
    }

    var hasPremium: Bool {
        purchasedProductIDs.contains(Self.premiumID)
    }

    var removeAdsProduct: Product? {
        products.first { $0.id == Self.removeAdsID }
    }

    var premiumProduct: Product? {
        products.first { $0.id == Self.premiumID }
    }

    /// Factory method to create and initialize StoreService asynchronously
    static func create() async -> StoreService {
        let service = StoreService()
        await service.initialize()
        return service
    }

    private init() {
        // Don't start tasks here - use async initialize instead
    }

    private func initialize() async {
        guard !isInitialized else { return }
        isInitialized = true

        // Start transaction listener
        transactionListener = listenForTransactions()

        // Load products and purchases
        await loadProducts()
        await updatePurchasedProducts()
    }

    deinit {
        transactionListener?.cancel()
    }

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            products = try await Product.products(for: [Self.removeAdsID, Self.premiumID])
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await updatePurchasedProducts()
            return true
        case .userCancelled:
            return false
        case .pending:
            return false
        @unknown default:
            return false
        }
    }

    func restorePurchases() async {
        try? await AppStore.sync()
        await updatePurchasedProducts()
    }

    private func updatePurchasedProducts() async {
        var purchased: Set<String> = []
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchased.insert(transaction.productID)
            }
        }
        purchasedProductIDs = purchased
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await transaction.finish()
                    await self?.updatePurchasedProducts()
                }
            }
        }
    }

    private nonisolated func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }
}

nonisolated enum StoreError: Error, LocalizedError, Sendable {
    case verificationFailed

    var errorDescription: String? {
        switch self {
        case .verificationFailed:
            return "Transaction verification failed."
        }
    }
}
