import SwiftUI

struct TextToolView: View {
    let hasPremium: Bool
    @Environment(\.dismiss) private var dismiss
    @Environment(StoreService.self) private var storeService
    @State private var text: String = ""
    @State private var selectedFontIndex: Int = 0
    @State private var showUpgrade: Bool = false
    let onTextAdded: (String, String) -> Void

    private var fonts: [(name: String, displayName: String, isPremium: Bool)] {
        let base: [(name: String, displayName: String)] = [
            ("Georgia", "Serif Classic"),
            ("Palatino", "Palatino"),
            ("Baskerville", "Baskerville"),
            ("Cochin", "Cochin"),
            ("Didot", "Didot"),
            ("AmericanTypewriter", "Typewriter"),
            ("Copperplate", "Copperplate"),
            ("Papyrus", "Papyrus"),
            ("MarkerFelt-Wide", "Marker"),
            ("ChalkboardSE-Regular", "Chalkboard"),
        ]
        return base.map { (name: $0.name, displayName: $0.displayName, isPremium: false) }
            + PremiumContent.extraFonts.map { (name: $0.name, displayName: $0.displayName, isPremium: true) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Enter your text...", text: $text, axis: .vertical)
                    .font(.custom(fonts[selectedFontIndex].name, size: 20))
                    .textFieldStyle(.plain)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemGroupedBackground))
                    )
                    .padding(.horizontal)
                    .lineLimit(1...5)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(fonts.enumerated()), id: \.offset) { index, font in
                            let isLocked = font.isPremium && !hasPremium
                            Button {
                                if isLocked {
                                    showUpgrade = true
                                } else {
                                    selectedFontIndex = index
                                }
                            } label: {
                                ZStack(alignment: .bottomTrailing) {
                                    Text("Abc")
                                        .font(.custom(font.name, size: 18))
                                        .foregroundStyle(selectedFontIndex == index ? .white : .primary)
                                        .frame(width: 64, height: 44)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(selectedFontIndex == index
                                                      ? Color(red: 0.4, green: 0.3, blue: 0.55)
                                                      : Color(.tertiarySystemGroupedBackground))
                                        )
                                        .opacity(isLocked ? 0.58 : 1)

                                    if isLocked {
                                        Image(systemName: "lock.fill")
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundStyle(.white)
                                            .padding(4)
                                            .background(Circle().fill(Color(red: 0.4, green: 0.3, blue: 0.55)))
                                            .offset(x: 4, y: 4)
                                    }
                                }
                            }
                            .accessibilityLabel(isLocked ? "\(font.displayName), Premium" : font.displayName)
                        }
                    }
                    .contentMargins(.horizontal, 16)
                }

                Text(fonts[selectedFontIndex].displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding(.top, 20)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Add Text")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if !text.isEmpty {
                            onTextAdded(text, fonts[selectedFontIndex].name)
                        }
                        dismiss()
                    }
                    .disabled(text.isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .sheet(isPresented: $showUpgrade) {
            UpgradeView(context: .premiumFonts, storeService: storeService)
        }
    }
}
