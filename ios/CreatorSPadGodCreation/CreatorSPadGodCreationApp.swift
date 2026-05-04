import SwiftUI
import SwiftData
import GoogleMobileAds
import AppTrackingTransparency

@main
struct CreatorSPadGodCreationApp: App {
    @State private var settingsVM = SettingsViewModel()
    @State private var storeService: StoreService?
    @State private var isInitializing = true

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Artwork.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        // Initialize AdMob on next run loop to avoid blocking app launch
        DispatchQueue.main.async {
            AdMobService.initialize()
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if isInitializing || storeService == nil {
                    SplashView()
                        .onAppear {
                            initializeApp()
                        }
                } else {
                    ContentView()
                        .environment(settingsVM)
                        .environment(storeService!)
                        .preferredColorScheme(settingsVM.preferredColorScheme)
                        .onAppear {
                            requestTrackingPermission()
                        }
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }

    private func initializeApp() {
        Task { @MainActor in
            // Initialize StoreService asynchronously to avoid blocking main thread
            storeService = await StoreService.create()
            // Small delay to ensure smooth transition
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            isInitializing = false
        }
    }

    private func requestTrackingPermission() {
        // Delay slightly to ensure the app is fully launched
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    DispatchQueue.main.async {
                        // Notify AdMobService that ATT status is determined
                        AdMobService.shared.trackingAuthorizationStatus = status

                        // Now safe to load ads
                        AdMobService.shared.loadInterstitial()
                        AdMobService.shared.loadRewarded()

                        switch status {
                        case .authorized:
                            print("ATT: Tracking authorized")
                        case .denied:
                            print("ATT: Tracking denied")
                        case .notDetermined:
                            print("ATT: Tracking not determined")
                        case .restricted:
                            print("ATT: Tracking restricted")
                        @unknown default:
                            print("ATT: Unknown status")
                        }
                    }
                }
            } else {
                // iOS 13 and below - load ads immediately
                AdMobService.shared.loadInterstitial()
                AdMobService.shared.loadRewarded()
            }
        }
    }
}

// Simple splash view shown during initialization
struct SplashView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "paintbrush.pointed.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.47, blue: 0.42),
                                Color(red: 0.4, green: 0.72, blue: 0.9)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Text("Creator's Pad")
                    .font(.system(.title, design: .serif, weight: .bold))
                    .foregroundStyle(.primary)

                Text("God Creation")
                    .font(.system(.title3, design: .serif))
                    .foregroundStyle(.secondary)

                ProgressView()
                    .padding(.top, 20)
            }
        }
    }
}
