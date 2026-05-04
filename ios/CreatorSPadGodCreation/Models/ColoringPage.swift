import Foundation

nonisolated struct ColoringPage: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let subtitle: String
    let scriptureReference: String
    let category: ColoringPageCategory
    let assetName: String
    let thumbnailAssetName: String
    let isPremium: Bool

    var accessLabel: String {
        isPremium ? "Premium" : "Free"
    }

    nonisolated static let allPages: [ColoringPage] = [
        ColoringPage(
            id: "adam-eve-garden-animals",
            title: "Adam and Eve with Animals",
            subtitle: "Adam and Eve in the garden with peaceful animals",
            scriptureReference: "GENESIS 2",
            category: .garden,
            assetName: "coloring-adam-eve-garden",
            thumbnailAssetName: "coloring-adam-eve-garden",
            isPremium: false
        ),
        ColoringPage(
            id: "creation-animals",
            title: "Creation Animals",
            subtitle: "Birds, fish, and animals from God's good creation",
            scriptureReference: "GENESIS 1",
            category: .creation,
            assetName: "coloring-creation-animals",
            thumbnailAssetName: "coloring-creation-animals",
            isPremium: false
        ),
        ColoringPage(
            id: "daniel-lions-den",
            title: "Daniel and the Lions",
            subtitle: "Daniel rests while God closes the lions' mouths",
            scriptureReference: "DANIEL 6",
            category: .oldTestament,
            assetName: "coloring-daniel-lions-den",
            thumbnailAssetName: "coloring-daniel-lions-den",
            isPremium: false
        ),
        ColoringPage(
            id: "noahs-ark",
            title: "Noah's Ark",
            subtitle: "Noah welcomes the animals on the ark under a rainbow",
            scriptureReference: "GENESIS 6-9",
            category: .ark,
            assetName: "coloring-noahs-ark",
            thumbnailAssetName: "coloring-noahs-ark",
            isPremium: true
        ),
        ColoringPage(
            id: "eden-animal-garden",
            title: "Garden Animal Friends",
            subtitle: "Lions, lambs, birds, and flowers in the garden",
            scriptureReference: "GENESIS 1-2",
            category: .animals,
            assetName: "coloring-garden-animal-friends",
            thumbnailAssetName: "coloring-garden-animal-friends",
            isPremium: true
        )
    ]

    nonisolated static let freePages = allPages.filter { !$0.isPremium }
    nonisolated static let premiumPages = allPages.filter(\.isPremium)

    nonisolated static func page(withID id: String?) -> ColoringPage? {
        guard let id else { return nil }
        return allPages.first { $0.id == id }
    }
}

nonisolated enum ColoringPageCategory: String, CaseIterable, Sendable {
    case creation = "Creation"
    case garden = "Garden"
    case ark = "Noah's Ark"
    case oldTestament = "Old Testament"
    case animals = "Animals"

    var symbolName: String {
        switch self {
        case .creation: return "sun.max.fill"
        case .garden: return "leaf.fill"
        case .ark: return "drop.fill"
        case .oldTestament: return "book.closed.fill"
        case .animals: return "pawprint.fill"
        }
    }
}

nonisolated enum ArtworkKind: String, Sendable {
    case freeform
    case coloringPage
}
