import SwiftUI
import SwiftData

struct GalleryView: View {
    @Query(sort: \Artwork.updatedAt, order: .reverse) private var artworks: [Artwork]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let onSelect: (Artwork) -> Void
    let onNew: () -> Void

    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                if artworks.isEmpty {
                    ContentUnavailableView(
                        "No Artworks Yet",
                        systemImage: "paintpalette",
                        description: Text("Start creating to fill your gallery!")
                    )
                    .padding(.top, 60)
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(artworks) { artwork in
                            GalleryCard(artwork: artwork) {
                                onSelect(artwork)
                                dismiss()
                            }
                            .contextMenu {
                                Button("Open", systemImage: "pencil.tip.crop.circle") {
                                    onSelect(artwork)
                                    dismiss()
                                }
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    modelContext.delete(artwork)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("My Creations")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("New", systemImage: "plus") {
                        onNew()
                        dismiss()
                    }
                }
            }
        }
    }
}

struct GalleryCard: View {
    let artwork: Artwork
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                Color(.secondarySystemBackground)
                    .frame(height: 140)
                    .overlay {
                        if let data = artwork.thumbnailData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .allowsHitTesting(false)
                        } else {
                            Image(systemName: "paintpalette")
                                .font(.largeTitle)
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .clipShape(.rect(cornerRadius: 12, style: .continuous))

                VStack(alignment: .leading, spacing: 2) {
                    Text(artwork.coloringPageTitle ?? artwork.verseReference)
                        .font(.system(.caption, design: artwork.artworkKind == .coloringPage ? .rounded : .serif, weight: .semibold))
                        .foregroundStyle(Color(red: 0.4, green: 0.3, blue: 0.55))
                        .lineLimit(1)

                    if artwork.artworkKind == .coloringPage {
                        Label("Coloring Page", systemImage: "book.closed.fill")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    Text(artwork.updatedAt, style: .relative)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 4)
                .padding(.top, 6)
                .padding(.bottom, 4)
            }
        }
    }
}
