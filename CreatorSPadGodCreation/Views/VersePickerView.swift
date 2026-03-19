import SwiftUI

struct VersePickerView: View {
    @Binding var selectedVerse: ScriptureVerse
    let hasPremium: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""

    private var allAvailableVerses: [ScriptureVerse] {
        hasPremium ? ScriptureVerse.allVerses + PremiumContent.extraVerses : ScriptureVerse.allVerses
    }

    private var filteredVerses: [ScriptureVerse] {
        if searchText.isEmpty {
            return allAvailableVerses
        }
        return allAvailableVerses.filter {
            $0.reference.localizedCaseInsensitiveContains(searchText) ||
            $0.text.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredVerses) { verse in
                Button {
                    selectedVerse = verse
                    dismiss()
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(verse.reference)
                                .font(.system(.headline, design: .serif))
                                .foregroundStyle(Color(red: 0.4, green: 0.3, blue: 0.55))

                            Spacer()

                            if verse.id == selectedVerse.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Color(red: 0.4, green: 0.75, blue: 0.72))
                            }
                        }

                        Text(verse.text)
                            .font(.system(.subheadline, design: .serif))
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .padding(.vertical, 4)
                }
            }
            .searchable(text: $searchText, prompt: "Search verses...")
            .navigationTitle("Choose a Verse")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
