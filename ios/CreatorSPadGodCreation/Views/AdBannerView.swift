import SwiftUI
import GoogleMobileAds

struct AdBannerView: View {
    @State private var isReady = false

    var body: some View {
        Group {
            if isReady {
                BannerAdRepresentable(adUnitID: AdMobService.bannerID)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
            } else {
                // Placeholder while waiting for ad
                Color.clear
                    .frame(height: 50)
            }
        }
        .onAppear {
            // Delay showing the banner to ensure view hierarchy is ready
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isReady = true
            }
        }
    }
}

private struct BannerAdRepresentable: UIViewRepresentable {
    typealias UIViewType = BannerView

    let adUnitID: String

    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = adUnitID
        banner.rootViewController = context.coordinator.rootViewController()
        banner.load(Request())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
        func rootViewController() -> UIViewController? {
            // Get the key window's root view controller more reliably
            let scenes = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .filter { $0.activationState == .foregroundActive }

            return scenes.first?.windows
                .first(where: { $0.isKeyWindow })?.rootViewController
                ?? scenes.first?.windows.first?.rootViewController
        }
    }
}
