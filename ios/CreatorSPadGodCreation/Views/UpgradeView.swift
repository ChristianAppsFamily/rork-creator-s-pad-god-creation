import SwiftUI
import StoreKit

struct UpgradeView: View {
    @Environment(\.dismiss) private var dismiss
    let context: UpgradeContext = .coloringPages
    @Bindable var storeService: StoreService
    @State private var isPurchasing: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    benefits
                    purchaseButtons
                    restoreButton
                }
                .padding(24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(context.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Not Now") { dismiss() }
                }
            }
            .alert("Purchase Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "crown.fill")
                .font(.system(size: 52))
                .foregroundStyle(Color(red: 0.95, green: 0.75, blue: 0.2))

            Text(context.title)
                .font(.title2.weight(.bold))
                .multilineTextAlignment(.center)

            Text(context.message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private var benefits: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(context.benefits, id: \.text) { item in
                benefit(item.symbolName, item.text)
            }
            benefit("rectangle.slash.fill", "Premium also removes ads")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private func benefit(_ symbolName: String, _ text: String) -> some View {
        Label {
            Text(text)
                .font(.subheadline)
        } icon: {
            Image(systemName: symbolName)
                .foregroundStyle(Color(red: 0.4, green: 0.75, blue: 0.72))
        }
    }

    private var purchaseButtons: some View {
        VStack(spacing: 12) {
            if storeService.hasPremium {
                activeRow(title: "Premium Active", subtitle: "All coloring pages and ads removal are unlocked.", symbolName: "crown.fill")
            } else if let product = storeService.premiumProduct {
                purchaseButton(
                    title: "Unlock Premium",
                    subtitle: "All coloring pages, colors, fonts, and remove ads",
                    product: product,
                    symbolName: "crown.fill"
                )
            } else {
                unavailableRow(title: "Premium", subtitle: "Product unavailable in this test environment.")
            }

            if !storeService.hasRemovedAds {
                if let product = storeService.removeAdsProduct {
                    purchaseButton(
                        title: "Remove Ads Only",
                        subtitle: "Keep free pages, hide ads",
                        product: product,
                        symbolName: "rectangle.slash.fill"
                    )
                }
            }
        }
    }

    private func purchaseButton(title: String, subtitle: String, product: Product, symbolName: String) -> some View {
        let isPremiumProduct = product.id == StoreService.premiumID
        Button {
            Task { await purchase(product) }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: symbolName)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(Circle().fill(isPremiumProduct ? Color(red: 0.95, green: 0.75, blue: 0.2) : Color(red: 0.4, green: 0.3, blue: 0.55)))

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(product.displayPrice)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(Capsule().fill(Color.accentColor))
            }
            .foregroundStyle(.primary)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
        }
        .disabled(isPurchasing)
        .buttonStyle(.plain)
    }

    private func activeRow(title: String, subtitle: String, symbolName: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: symbolName)
                .font(.title2)
                .foregroundStyle(.green)
                .frame(width: 42, height: 42)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private func unavailableRow(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private var restoreButton: some View {
        Button {
            Task {
                await storeService.restorePurchases()
                if storeService.hasPremium || storeService.hasRemovedAds {
                    dismiss()
                }
            }
        } label: {
            Label("Restore Purchases", systemImage: "arrow.clockwise")
                .font(.subheadline.weight(.semibold))
        }
        .disabled(isPurchasing)
    }

    private func purchase(_ product: Product) async {
        isPurchasing = true
        defer { isPurchasing = false }

        do {
            let completed = try await storeService.purchase(product)
            if completed {
                dismiss()
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

nonisolated enum UpgradeContext: Sendable {
    case coloringPages
    case premiumColors
    case premiumFonts

    var navigationTitle: String {
        switch self {
        case .coloringPages: return "Unlock More Pages"
        case .premiumColors: return "Unlock Colors"
        case .premiumFonts: return "Unlock Fonts"
        }
    }

    var title: String {
        switch self {
        case .coloringPages: return "More Bible Coloring Pages"
        case .premiumColors: return "Premium Colors"
        case .premiumFonts: return "Premium Fonts"
        }
    }

    var message: String {
        switch self {
        case .coloringPages:
            return "Your family gets \(ColoringPage.freePages.count) free starter pages. Premium unlocks the full Bible coloring library plus extra creative tools."
        case .premiumColors:
            return "Unlock more beautiful colors for Bible art and coloring pages. Premium also unlocks all coloring pages, fonts, and removes ads."
        case .premiumFonts:
            return "Unlock more creative Bible verse lettering styles. Premium also unlocks all coloring pages, colors, and removes ads."
        }
    }

    var benefits: [(symbolName: String, text: String)] {
        switch self {
        case .coloringPages:
            return [
                ("paintpalette.fill", "Unlock every animal and Old Testament coloring page"),
                ("book.closed.fill", "Garden, Ark, Daniel, Noah, and more"),
                ("slider.horizontal.3", "Premium colors, fonts, and creative tools")
            ]
        case .premiumColors:
            return [
                ("paintpalette.fill", "Unlock the full color palette"),
                ("book.closed.fill", "Use premium colors on every coloring page"),
                ("textformat", "Premium also includes extra fonts")
            ]
        case .premiumFonts:
            return [
                ("textformat", "Unlock premium lettering styles"),
                ("book.closed.fill", "Create richer Bible verse artwork"),
                ("paintpalette.fill", "Premium also includes extra colors")
            ]
        }
    }
}
