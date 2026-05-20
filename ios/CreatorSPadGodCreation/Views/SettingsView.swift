import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var settingsVM: SettingsViewModel
    @Bindable var storeService: StoreService
    @State private var isPurchasing: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationStack {
            List {
                appearanceSection
                soundSection
                pencilSection
                textSection
                purchasesSection
                aboutSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    private var appearanceSection: some View {
        Section {
            Picker("Appearance", selection: $settingsVM.appearanceMode) {
                ForEach(AppearanceMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
        } header: {
            Label("Appearance", systemImage: "paintbrush.fill")
        } footer: {
            Text("Choose how the app looks. System follows your device setting.")
        }
    }

    private var soundSection: some View {
        Section {
            Toggle(isOn: $settingsVM.soundEffectsEnabled) {
                Label("Sound Effects", systemImage: "speaker.wave.2.fill")
            }
        } header: {
            Label("Audio", systemImage: "waveform")
        }
    }

    private var pencilSection: some View {
        Section {
            Toggle(isOn: $settingsVM.pencilPressureSensitivity) {
                Label("Pressure Sensitivity", systemImage: "applepencil.tip")
            }

            Picker(selection: $settingsVM.pencilDoubleTapAction) {
                ForEach(PencilDoubleTapAction.allCases, id: \.self) { action in
                    Text(action.rawValue).tag(action)
                }
            } label: {
                Label("Double-Tap Action", systemImage: "hand.tap.fill")
            }
        } header: {
            Label("Apple Pencil", systemImage: "applepencil")
        }
    }

    private var textSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label("Text Size", systemImage: "textformat.size")
                    Spacer()
                    Text("\(Int(settingsVM.textSizeMultiplier * 100))%")
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                Slider(value: $settingsVM.textSizeMultiplier, in: 0.75...1.5, step: 0.05)
                    .tint(Color(red: 0.4, green: 0.75, blue: 0.72))
            }
        } header: {
            Label("Text", systemImage: "textformat")
        }
    }

    private var purchasesSection: some View {
        Section {
            if !storeService.hasRemovedAds {
                if let product = storeService.removeAdsProduct {
                    purchaseRow(
                        icon: "xmark.rectangle.fill",
                        iconColor: Color(red: 1.0, green: 0.47, blue: 0.42),
                        title: "Remove Ads",
                        subtitle: "One-time purchase",
                        price: product.displayPrice,
                        product: product
                    )
                }
            } else if !storeService.hasPremium {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.green)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Ads Removed")
                            .font(.subheadline.weight(.semibold))
                        Text("Thank you for your support!")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            if !storeService.hasPremium {
                if let product = storeService.premiumProduct {
                    purchaseRow(
                        icon: "crown.fill",
                        iconColor: Color(red: 0.95, green: 0.75, blue: 0.2),
                        title: "Premium Unlock",
                        subtitle: "30 verses, 15 fonts, 20 colors, cloud backup",
                        price: product.displayPrice,
                        product: product
                    )
                }
            } else {
                HStack(spacing: 12) {
                    Image(systemName: "crown.fill")
                        .font(.title2)
                        .foregroundStyle(Color(red: 0.95, green: 0.75, blue: 0.2))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Premium Active")
                            .font(.subheadline.weight(.semibold))
                        Text("All features unlocked!")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Button {
                Task {
                    await storeService.restorePurchases()
                }
            } label: {
                Label("Restore Purchases", systemImage: "arrow.clockwise")
            }
        } header: {
            Label("Purchases", systemImage: "bag.fill")
        } footer: {
            Text("Purchases support Family Sharing. All family members get access.")
        }
    }

    private func purchaseRow(icon: String, iconColor: Color, title: String, subtitle: String, price: String, product: Product) -> some View {
        Button {
            Task {
                isPurchasing = true
                defer { isPurchasing = false }
                do {
                    _ = try await storeService.purchase(product)
                } catch {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(iconColor)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(price)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.accentColor)
                    )
            }
        }
        .disabled(isPurchasing)
    }

    private var aboutSection: some View {
        Section {
            Button {
                requestReview()
            } label: {
                Label("Rate This App", systemImage: "star.fill")
            }

            ShareLink(item: URL(string: "https://apps.apple.com/app/creators-pad")!) {
                Label("Share with Friends", systemImage: "square.and.arrow.up")
            }
        } header: {
            Label("About", systemImage: "info.circle.fill")
        }
    }

    private func requestReview() {
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
        AppStore.requestReview(in: scene)
    }
}
