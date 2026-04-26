import SwiftUI

struct ColoringPageLibraryView: View {
    let hasPremium: Bool
    let onSelect: (ColoringPage) -> Void
    let onUpgradeRequested: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: ColoringPageCategory?

    private let columns = [
        GridItem(.adaptive(minimum: 210), spacing: 16)
    ]

    private var visiblePages: [ColoringPage] {
        guard let selectedCategory else {
            return ColoringPage.allPages
        }
        return ColoringPage.allPages.filter { $0.category == selectedCategory }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    heroSection
                    categoryFilter
                    pageGrid
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Bible Coloring Pages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Free Starter Pages", systemImage: "paintpalette.fill")
                .font(.headline)
                .foregroundStyle(Color(red: 0.4, green: 0.3, blue: 0.55))

            Text("Start with \(ColoringPage.freePages.count) free Bible animal pages. Unlock the full Old Testament coloring library when your family wants more.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.85, blue: 0.25).opacity(0.18),
                            Color(red: 0.4, green: 0.75, blue: 0.72).opacity(0.14),
                            Color(red: 0.6, green: 0.5, blue: 0.8).opacity(0.14)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                categoryButton(title: "All", symbolName: "square.grid.2x2.fill", category: nil)

                ForEach(ColoringPageCategory.allCases, id: \.self) { category in
                    categoryButton(title: category.rawValue, symbolName: category.symbolName, category: category)
                }
            }
        }
    }

    private func categoryButton(title: String, symbolName: String, category: ColoringPageCategory?) -> some View {
        let isSelected = selectedCategory == category
        return Button {
            selectedCategory = category
        } label: {
            Label(title, systemImage: symbolName)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color(red: 0.4, green: 0.3, blue: 0.55) : Color(.secondarySystemGroupedBackground))
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
    }

    private var pageGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(visiblePages) { page in
                ColoringPageCard(
                    page: page,
                    isLocked: page.isPremium && !hasPremium
                ) {
                    if page.isPremium && !hasPremium {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            onUpgradeRequested()
                        }
                    } else {
                        onSelect(page)
                        dismiss()
                    }
                }
            }
        }
    }
}

private struct ColoringPageCard: View {
    let page: ColoringPage
    let isLocked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .topTrailing) {
                    ColoringPageTemplateView(page: page, showsTitle: false)
                        .frame(height: 170)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .clipShape(.rect(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .strokeBorder(Color(.separator), lineWidth: 1)
                        )
                        .saturation(isLocked ? 0.1 : 1)
                        .opacity(isLocked ? 0.62 : 1)

                    accessBadge
                        .padding(10)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(page.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(page.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)

                    Label(page.scriptureReference, systemImage: page.category.symbolName)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Color(red: 0.4, green: 0.3, blue: 0.55))
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(page.title), \(page.accessLabel)")
    }

    private var accessBadge: some View {
        Label(isLocked ? "Unlock" : page.accessLabel, systemImage: isLocked ? "lock.fill" : "checkmark.circle.fill")
            .font(.caption2.weight(.bold))
            .padding(.horizontal, 9)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(isLocked ? Color(red: 0.95, green: 0.75, blue: 0.2) : Color(red: 0.4, green: 0.75, blue: 0.72))
            )
            .foregroundStyle(.white)
    }
}
