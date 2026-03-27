import SwiftUI
import GoogleMobileAds

struct AdBannerView: View {
    var body: some View {
        BannerAdRepresentable(adUnitID: AdMobService.bannerID)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
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
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .first?.rootViewController
        }
    }
}
