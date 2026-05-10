import SwiftUI
import SwiftData

struct HistoryScreen: View {
    @Query(sort: \TranslationRecord.createdAt, order: .reverse)
    private var records: [TranslationRecord]

    @State private var searchText = ""
    @Environment(\.modelContext) private var modelContext

    var filteredRecords: [TranslationRecord] {
        if searchText.isEmpty { return records }
        return records.filter {
            $0.originalText.localizedCaseInsensitiveContains(searchText) ||
            $0.translatedText.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        Group {
            if records.isEmpty {
                EmptyStateView(
                    icon: "clock.arrow.circlepath",
                    title: "No Translations Yet",
                    subtitle: "Your translation history will appear here."
                )
            } else {
                List {
                    ForEach(filteredRecords) { record in
                        NavigationLink {
                            HistoryDetailView(record: record)
                        } label: {
                            HistoryRowView(record: record)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                record.isFavorite.toggle()
                                modelContext.safeSave()
                            } label: {
                                Label(
                                    record.isFavorite ? "Unfavorite" : "Favorite",
                                    systemImage: record.isFavorite ? "heart.slash" : "heart"
                                )
                            }
                            .tint(.pink)
                        }
                    }
                    .onDelete(perform: deleteRecords)
                }
                .searchable(text: $searchText, prompt: "Search translations")
            }
        }
        .navigationTitle("History")
    }

    private func deleteRecords(at offsets: IndexSet) {
        for index in offsets {
            guard index >= 0 && index < filteredRecords.count else { continue }
            let record = filteredRecords[index]
            modelContext.delete(record)
        }
        modelContext.safeSave()
    }
}

struct HistoryRowView: View {
    let record: TranslationRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("\(record.sourceLanguage.capitalized) \u{2192} \(record.targetLanguage.capitalized)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                if record.isFavorite {
                    Image(systemName: "heart.fill")
                        .font(.caption)
                        .foregroundStyle(.pink)
                }
                Text(record.createdAt, style: .relative)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Text(record.originalText)
                .font(.subheadline)
                .lineLimit(2)

            Text(record.translatedText)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.indigo)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}

struct HistoryDetailView: View {
    @Bindable var record: TranslationRecord
    @Environment(\.modelContext) private var modelContext
    @StateObject private var tts = TextToSpeechManager()

    var body: some View {
        ScrollView {
            TranslationResultCard(
                response: record.asResponse,
                onSpeak: {
                    let lang = SupportedLanguage(rawValue: record.targetLanguage) ?? .sanskrit
                    tts.speak(text: record.translatedText, language: lang, transliteration: record.transliteration)
                },
                isSpeaking: tts.isSpeaking,
                onFavorite: {
                    record.isFavorite.toggle()
                    modelContext.safeSave()
                },
                isFavorited: record.isFavorite
            )
            .padding(.top)
        }
        .navigationTitle("Translation Detail")
    }
}
