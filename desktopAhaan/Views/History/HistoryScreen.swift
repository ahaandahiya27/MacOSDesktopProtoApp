import SwiftUI
import AppKit

struct HistoryScreen: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var searchText = ""
    @State private var selectedRecordId: UUID? = nil

    var records: [TranslationRecord] {
        dataStore.recordsByDate
    }

    var filteredRecords: [TranslationRecord] {
        if searchText.isEmpty { return records }
        return records.filter {
            $0.originalText.localizedCaseInsensitiveContains(searchText) ||
            $0.translatedText.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            if selectedRecordId != nil {
                HStack {
                    Button {
                        withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) {
                            selectedRecordId = nil
                        }
                    } label: {
                        HStack(spacing: DesignTokens.Spacing.xs) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    .accessibilityIdentifier("history-detail-back")
                    Spacer()
                }
                .padding(.horizontal, DesignTokens.Spacing.lg)
                .padding(.vertical, DesignTokens.Spacing.sm)
                .background(Color(NSColor.controlBackgroundColor))
                Divider()
            }

            if let id = selectedRecordId,
               let record = records.first(where: { $0.id == id }) {
                HistoryDetailView(record: record)
            } else {
                historyList
            }
        }
        .navigationTitle(selectedRecordId == nil ? "History" : "Translation Detail")
        .onReceive(NotificationCenter.default.publisher(for: .navigateBackCommand)) { _ in
            if selectedRecordId != nil {
                withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) {
                    selectedRecordId = nil
                }
            }
        }
    }

    @ViewBuilder
    private var historyList: some View {
        if records.isEmpty {
            EmptyStateView(
                icon: "clock.arrow.circlepath",
                title: "No Translations Yet",
                subtitle: "Your translation history will appear here."
            )
        } else {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search translations", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityIdentifier("history-search-field")
                }
                .padding(.horizontal)
                .padding(.vertical, DesignTokens.Spacing.sm)

                List {
                    ForEach(filteredRecords) { record in
                        Button {
                            withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) {
                                selectedRecordId = record.id
                            }
                        } label: {
                            HistoryRowView(record: record)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint("Opens the full translation detail view")
                        .accessibilityIdentifier("history-row-\(record.id)")
                        .contextMenu {
                            Button {
                                dataStore.toggleRecordFavorite(record)
                            } label: {
                                Text(record.isFavorite ? "Unfavorite" : "Favorite")
                                Image(systemName: record.isFavorite ? "heart.slash" : "heart")
                            }
                            .accessibilityHint("Toggles this translation as a saved favorite")
                            Button {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(record.translatedText, forType: .string)
                            } label: {
                                Text("Copy translation")
                                Image(systemName: "doc.on.doc")
                            }
                            .accessibilityHint("Copies the translation text to the clipboard")
                            Divider()
                            Button {
                                dataStore.delete(record)
                            } label: {
                                Text("Delete")
                                Image(systemName: "trash")
                            }
                        }
                    }
                    .onDelete(perform: deleteRecords)
                }
            }
        }
    }

    private func deleteRecords(at offsets: IndexSet) {
        for index in offsets {
            guard index >= 0 && index < filteredRecords.count else { continue }
            let record = filteredRecords[index]
            dataStore.delete(record)
        }
    }
}

struct HistoryRowView: View {
    let record: TranslationRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("\(record.sourceLanguage.capitalized) → \(record.targetLanguage.capitalized)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                if record.isFavorite {
                    Image(systemName: "heart.fill")
                        .font(.caption)
                        .foregroundColor(.pink)
                }
                Text(record.createdAt, style: .relative)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Text(record.originalText)
                .font(.subheadline)
                .lineLimit(2)

            Text(record.translatedText)
                .font(.subheadline.weight(.medium))
                .foregroundColor(Color.compatIndigo)
                .lineLimit(2)
        }
        .padding(.vertical, DesignTokens.Spacing.xs)
    }
}

struct HistoryDetailView: View {
    let record: TranslationRecord
    @EnvironmentObject var dataStore: DataStore
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
                    dataStore.toggleRecordFavorite(record)
                },
                isFavorited: record.isFavorite
            )
            .padding(.top)
        }
    }
}
