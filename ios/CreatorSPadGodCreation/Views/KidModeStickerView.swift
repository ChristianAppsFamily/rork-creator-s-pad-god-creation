import SwiftUI

struct KidModeStickerView: View {
    @Environment(\.dismiss) private var dismiss
    let onStickerSelected: (String) -> Void

    private let stickers: [(symbol: String, label: String)] = [
        ("cross.fill", "Cross"),
        ("fish.fill", "Fish"),
        ("bird.fill", "Dove"),
        ("heart.fill", "Heart"),
        ("star.fill", "Star"),
        ("sun.max.fill", "Sun"),
        ("moon.fill", "Moon"),
        ("leaf.fill", "Leaf"),
        ("drop.fill", "Water"),
        ("flame.fill", "Flame"),
        ("rainbow", "Rainbow"),
        ("globe.americas.fill", "World"),
    ]

    private let columns = [
        GridItem(.adaptive(minimum: 70), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(stickers, id: \.symbol) { sticker in
                        Button {
                            onStickerSelected(sticker.symbol)
                            dismiss()
                        } label: {
                            VStack(spacing: 6) {
                                Image(systemName: sticker.symbol)
                                    .font(.system(size: 36))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.85, green: 0.45, blue: 0.55),
                                                Color(red: 0.55, green: 0.45, blue: 0.85),
                                                Color(red: 0.4, green: 0.75, blue: 0.72)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 60, height: 60)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color(.secondarySystemGroupedBackground))
                                    )
                                Text(sticker.label)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Stamps")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
