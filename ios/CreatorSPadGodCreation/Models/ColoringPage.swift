import Foundation

nonisolated struct ColoringPage: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let subtitle: String
    let scriptureReference: String
    let category: ColoringPageCategory
    let isPremium: Bool

    var accessLabel: String {
        isPremium ? "Premium" : "Free"
    }

    nonisolated static let allPages: [ColoringPage] = [
        ColoringPage(
            id: "creation-animals",
            title: "Creation Animals",
            subtitle: "Birds, fish, and animals from God's good creation",
            scriptureReference: "GENESIS 1",
            category: .creation,
            isPremium: false
        ),
        ColoringPage(
            id: "noahs-ark",
            title: "Noah's Ark",
            subtitle: "Animal pairs gathered safely on the ark",
            scriptureReference: "GENESIS 6-9",
            category: .ark,
            isPremium: false
        ),
        ColoringPage(
            id: "daniel-lions-den",
            title: "Daniel and the Lions",
            subtitle: "Daniel rests while God closes the lions' mouths",
            scriptureReference: "DANIEL 6",
            category: .oldTestament,
            isPremium: false
        ),
        ColoringPage(
            id: "garden-of-eden",
            title: "Garden of Eden",
            subtitle: "Adam, Eve, and peaceful garden animals",
            scriptureReference: "GENESIS 2",
            category: .garden,
            isPremium: true
        ),
        ColoringPage(
            id: "samson-lion",
            title: "Samson and the Lion",
            subtitle: "Samson's strength in an Old Testament adventure",
            scriptureReference: "JUDGES 14",
            category: .oldTestament,
            isPremium: true
        ),
        ColoringPage(
            id: "david-shepherd",
            title: "David the Shepherd",
            subtitle: "David watches over sheep in the fields",
            scriptureReference: "1 SAMUEL 17",
            category: .oldTestament,
            isPremium: true
        ),
        ColoringPage(
            id: "jonah-big-fish",
            title: "Jonah and the Great Fish",
            subtitle: "Jonah's ocean story with waves and fish",
            scriptureReference: "JONAH 1-2",
            category: .oldTestament,
            isPremium: true
        ),
        ColoringPage(
            id: "baby-moses-river",
            title: "Baby Moses",
            subtitle: "A basket floats safely along the river reeds",
            scriptureReference: "EXODUS 2",
            category: .oldTestament,
            isPremium: true
        ),
        ColoringPage(
            id: "eden-animal-garden",
            title: "Garden Animal Friends",
            subtitle: "Lions, lambs, birds, and flowers in the garden",
            scriptureReference: "GENESIS 1-2",
            category: .animals,
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
