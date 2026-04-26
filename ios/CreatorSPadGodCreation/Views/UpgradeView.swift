import SwiftUI
import StoreKit

struct UpgradeView: View {
    @Environment(\.dismiss) private var dismiss
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
            .navigationTitle("Unlock More Pages")
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

            Text("More Bible Coloring Pages")
                .font(.title2.weight(.bold))
                .multilineTextAlignment(.center)

            Text("Your family gets \(ColoringPage.freePages.count) free starter pages. Premium unlocks the full Bible coloring library plus extra creative tools.")
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
            benefit("paintpalette.fill", "Unlock every animal and Old Testament coloring page")
            benefit("book.closed.fill", "Garden, Ark, Samson, Daniel, Jonah, Moses, and more")
            benefit("slider.horizontal.3", "Premium colors, fonts, and creative tools")
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
