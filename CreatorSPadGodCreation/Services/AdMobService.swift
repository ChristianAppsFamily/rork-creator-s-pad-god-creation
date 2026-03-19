import GoogleMobileAds
import UIKit

@Observable
@MainActor
class AdMobService {
    private(set) var isInterstitialReady: Bool = false
    private(set) var isRewardedReady: Bool = false

    @ObservationIgnored private var interstitialAd: InterstitialAd?
    @ObservationIgnored private var rewardedAd: RewardedAd?

    static let shared = AdMobService()

    private static var bannerAdUnitID: String {
        #if DEBUG
        return "ca-app-pub-3940256099942544/2934735716"
        #else
        return (Bundle.main.object(forInfoDictionaryKey: "ADMOB_BANNER_AD_UNIT_ID") as? String) ?? ""
        #endif
    }

    static var bannerID: String { bannerAdUnitID }

    private static var interstitialAdUnitID: String {
        #if DEBUG
        return "ca-app-pub-3940256099942544/4411468910"
        #else
        return (Bundle.main.object(forInfoDictionaryKey: "ADMOB_INTERSTITIAL_AD_UNIT_ID") as? String) ?? ""
        #endif
    }

    private static var rewardedAdUnitID: String {
        #if DEBUG
        return "ca-app-pub-3940256099942544/1712485313"
        #else
        return (Bundle.main.object(forInfoDictionaryKey: "ADMOB_REWARDED_AD_UNIT_ID") as? String) ?? ""
        #endif
    }

    static func initialize() {
        MobileAds.shared.start { _ in }
    }

    func loadInterstitial() {
        InterstitialAd.load(with: Self.interstitialAdUnitID, request: Request()) { [weak self] ad, error in
            guard let self else { return }
            if let ad {
                self.interstitialAd = ad
                self.isInterstitialReady = true
            } else {
                self.isInterstitialReady = false
            }
        }
    }

    func loadRewarded() {
        RewardedAd.load(with: Self.rewardedAdUnitID, request: Request()) { [weak self] ad, error in
            guard let self else { return }
            if let ad {
                self.rewardedAd = ad
                self.isRewardedReady = true
            } else {
                self.isRewardedReady = false
            }
        }
    }

    func showInterstitial(from viewController: UIViewController) {
        guard let ad = interstitialAd else { return }
        ad.present(from: viewController)
        interstitialAd = nil
        isInterstitialReady = false
        loadInterstitial()
    }

    func showRewarded(from viewController: UIViewController, onEarned: @escaping () -> Void) {
        guard let ad = rewardedAd else { return }
        ad.present(from: viewController) {
            onEarned()
        }
        rewardedAd = nil
        isRewardedReady = false
        loadRewarded()
    }
}
