import SwiftData
import Foundation

@Model
class Artwork {
    var id: UUID
    var verseReference: String
    var verseText: String
    @Attribute(.externalStorage) var drawingData: Data?
    @Attribute(.externalStorage) var thumbnailData: Data?
    var createdAt: Date
    var updatedAt: Date

    init(verseReference: String = "GENESIS 1:1", verseText: String = "In the beginning God created the heavens and the earth.") {
        self.id = UUID()
        self.verseReference = verseReference
        self.verseText = verseText
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
