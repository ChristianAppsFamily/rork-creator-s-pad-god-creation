import SwiftData
import Foundation

@Model
class Artwork {
    var id: UUID
    var verseReference: String
    var verseText: String
    var artworkKindRawValue: String?
    var coloringPageID: String?
    var coloringPageTitle: String?
    @Attribute(.externalStorage) var drawingData: Data?
    @Attribute(.externalStorage) var thumbnailData: Data?
    var createdAt: Date
    var updatedAt: Date

    var artworkKind: ArtworkKind {
        ArtworkKind(rawValue: artworkKindRawValue ?? "") ?? .freeform
    }

    init(
        verseReference: String = "GENESIS 1:1",
        verseText: String = "In the beginning God created the heavens and the earth.",
        artworkKind: ArtworkKind = .freeform,
        coloringPageID: String? = nil,
        coloringPageTitle: String? = nil
    ) {
        self.id = UUID()
        self.verseReference = verseReference
        self.verseText = verseText
        self.artworkKindRawValue = artworkKind.rawValue
        self.coloringPageID = coloringPageID
        self.coloringPageTitle = coloringPageTitle
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
