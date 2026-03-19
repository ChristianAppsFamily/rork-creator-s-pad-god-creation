import SwiftUI

struct TextToolView: View {
    let hasPremium: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""
    @State private var selectedFontIndex: Int = 0
    let onTextAdded: (String, String) -> Void

    private var fonts: [(name: String, displayName: String)] {
        var base: [(name: String, displayName: String)] = [
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
        if hasPremium {
            base.append(contentsOf: PremiumContent.extraFonts)
        }
        return base
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
                            Button {
                                selectedFontIndex = index
                            } label: {
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
                            }
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
    }
}
