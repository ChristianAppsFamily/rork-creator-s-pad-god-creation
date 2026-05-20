import SwiftUI
import SwiftData
import GoogleMobileAds

@main
struct CreatorSPadGodCreationApp: App {
    @State private var settingsVM = SettingsViewModel()
    @State private var storeService = StoreService()

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
        AdMobService.initialize()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(settingsVM)
                .environment(storeService)
                .preferredColorScheme(settingsVM.preferredColorScheme)
        }
        .modelContainer(sharedModelContainer)
    }
}
