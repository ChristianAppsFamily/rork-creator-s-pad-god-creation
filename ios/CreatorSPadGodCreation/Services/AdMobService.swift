import GoogleMobileAds
import UIKit
import AppTrackingTransparency

@Observable
@MainActor
class AdMobService {
    private(set) var isInterstitialReady: Bool = false
    private(set) var isRewardedReady: Bool = false
    private(set) var trackingAuthorizationStatus: ATTrackingManager.AuthorizationStatus = .notDetermined
    private var isInitialized = false

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
        // Ensure we're on main thread
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                initialize()
            }
            return
        }

        // Check if we have a valid ad unit ID configured
        let hasValidConfig = !bannerAdUnitID.isEmpty || !interstitialAdUnitID.isEmpty || !rewardedAdUnitID.isEmpty
        #if DEBUG
        // In debug, we use test IDs so always proceed
        #else
        guard hasValidConfig else {
            print("AdMob: No valid ad unit IDs configured. Skipping initialization.")
            return
        }
        #endif

        // Initialize Mobile Ads SDK
        MobileAds.shared.start { initializationStatus in
            print("AdMob initialized with status: \(initializationStatus)")
        }
    }

    func loadInterstitial() {
        guard !AdMobService.interstitialAdUnitID.isEmpty else { return }

        InterstitialAd.load(with: Self.interstitialAdUnitID, request: Request()) { [weak self] ad, error in
            guard let self else { return }
            if let ad {
                self.interstitialAd = ad
                self.isInterstitialReady = true
            } else {
                self.isInterstitialReady = false
                print("Failed to load interstitial: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }

    func loadRewarded() {
        guard !AdMobService.rewardedAdUnitID.isEmpty else { return }

        RewardedAd.load(with: Self.rewardedAdUnitID, request: Request()) { [weak self] ad, error in
            guard let self else { return }
            if let ad {
                self.rewardedAd = ad
                self.isRewardedReady = true
            } else {
                self.isRewardedReady = false
                print("Failed to load rewarded ad: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }

    func showInterstitial(from viewController: UIViewController) {
        guard let ad = interstitialAd else {
            // Try to reload if not ready
            loadInterstitial()
            return
        }
        ad.present(from: viewController)
        interstitialAd = nil
        isInterstitialReady = false
        loadInterstitial()
    }

    func showRewarded(from viewController: UIViewController, onEarned: @escaping () -> Void) {
        guard let ad = rewardedAd else {
            // Try to reload if not ready
            loadRewarded()
            return
        }
        ad.present(from: viewController) {
            onEarned()
        }
        rewardedAd = nil
        isRewardedReady = false
        loadRewarded()
    }
}
