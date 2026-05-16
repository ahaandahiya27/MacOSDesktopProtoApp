import SwiftUI
import AppKit

struct FavoritesScreen: View {
    @EnvironmentObject var dataStore: DataStore
    @StateObject private var tts = TextToSpeechManager()
    @State private var selectedRecordId: UUID? = nil

    var favorites: [TranslationRecord] {
        dataStore.favorites
    }

    var body: some View {
        VStack(spacing: 0) {
            if selectedRecordId != nil {
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedRecordId = nil
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(NSColor.controlBackgroundColor))
                Divider()
            }

            if let id = selectedRecordId,
               let record = favorites.first(where: { $0.id == id }) {
                HistoryDetailView(record: record)
            } else {
                favoritesList
            }
        }
        .navigationTitle(selectedRecordId == nil ? "Favorites" : "Translation Detail")
        .onReceive(NotificationCenter.default.publisher(for: .navigateBackCommand)) { _ in
            if selectedRecordId != nil {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedRecordId = nil
                }
            }
        }
    }

    @ViewBuilder
    private var favoritesList: some View {
        if favorites.isEmpty {
            EmptyStateView(
                icon: "heart",
                title: "No Favorites Yet",
                subtitle: "Tap the heart on any translation to save it here."
            )
        } else {
            List {
                ForEach(favorites) { record in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedRecordId = record.id
                        }
                    } label: {
                        FavoriteRowView(record: record, tts: tts)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(record.translatedText, forType: .string)
                        } label: {
                            Text("Copy translation")
                            Image(systemName: "doc.on.doc")
                        }
                        Divider()
                        Button {
                            dataStore.setFavorite(recordId: record.id, isFavorite: false)
                        } label: {
                            Text("Remove from favorites")
                            Image(systemName: "heart.slash")
                        }
                    }
                }
                .onDelete(perform: removeFavorites)
            }
        }
    }

    private func removeFavorites(at offsets: IndexSet) {
        for index in offsets {
            guard index >= 0 && index < favorites.count else { continue }
            let record = favorites[index]
            dataStore.setFavorite(recordId: record.id, isFavorite: false)
        }
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
                    .foregroundColor(Color.compatIndigo)
                    .lineLimit(2)

                Spacer()

                Button {
                    let lang = SupportedLanguage(rawValue: record.targetLanguage) ?? .sanskrit
                    tts.speak(text: record.translatedText, language: lang, transliteration: record.transliteration)
                } label: {
                    Image(systemName: tts.isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2")
                        .font(.caption)
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain)
                .help("Play pronunciation")
            }

            if let translit = record.transliteration, !translit.isEmpty {
                Text(translit)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .padding(.vertical, 4)
    }
}
