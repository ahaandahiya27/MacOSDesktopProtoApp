import SwiftUI
import SwiftData

struct FavoritesScreen: View {
    @Query(
        filter: #Predicate<TranslationRecord> { $0.isFavorite == true },
        sort: \TranslationRecord.createdAt,
        order: .reverse
    )
    private var favorites: [TranslationRecord]

    @Environment(\.modelContext) private var modelContext
    @StateObject private var tts = TextToSpeechManager()

    var body: some View {
        Group {
            if favorites.isEmpty {
                EmptyStateView(
                    icon: "heart",
                    title: "No Favorites Yet",
                    subtitle: "Tap the heart on any translation to save it here."
                )
            } else {
                List {
                    ForEach(favorites) { record in
                        NavigationLink {
                            HistoryDetailView(record: record)
                        } label: {
                            FavoriteRowView(record: record, tts: tts)
                        }
                    }
                    .onDelete(perform: removeFavorites)
                }
            }
        }
        .navigationTitle("Favorites")
    }

    private func removeFavorites(at offsets: IndexSet) {
        for index in offsets {
            guard index >= 0 && index < favorites.count else { continue }
            favorites[index].isFavorite = false
        }
        modelContext.safeSave()
    }
}

struct FavoriteRowView: View {
    let record: TranslationRecord
    @ObservedObject var tts: TextToSpeechManager

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(record.originalText)
                .font(.subheadline)
                .lineLimit(2)

            HStack {
                Text(record.translatedText)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.indigo)
                    .lineLimit(2)

                Spacer()

                Button {
                    let lang = SupportedLanguage(rawValue: record.targetLanguage) ?? .sanskrit
                    tts.speak(text: record.translatedText, language: lang, transliteration: record.transliteration)
                } label: {
                    Image(systemName: tts.isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2")
                        .font(.caption)
                        .foregroundStyle(.indigo)
                }
                .buttonStyle(.plain)
            }

            if let translit = record.transliteration, !translit.isEmpty {
                Text(translit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .italic()
            }
        }
        .padding(.vertical, 4)
    }
}
