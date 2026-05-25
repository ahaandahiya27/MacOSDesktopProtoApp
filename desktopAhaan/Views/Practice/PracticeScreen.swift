import SwiftUI

struct PracticeScreen: View {
    @StateObject private var vm = PracticeViewModel()
    @EnvironmentObject var dataStore: DataStore

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let phrase = vm.dailyPhrase {
                    DailyPhraseCard(item: phrase, onSpeak: {
                        vm.speak(text: phrase.sanskrit, language: .sanskrit, transliteration: phrase.transliteration)
                    })
                }

                switch vm.mode {
                case .categories:
                    CategoriesGrid(vm: vm)
                case .flashcards:
                    FlashcardView(vm: vm)
                case .quiz:
                    QuizView(vm: vm)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Practice")
        .toolbar {
            ToolbarItem {
                if vm.mode != .categories {
                    Button {
                        withAnimation {
                            vm.mode = .categories
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Topics")
                        }
                    }
                }
            }
        }
        .onAppear {
            vm.loadDailyPhrase()
        }
    }
}

// MARK: - Daily Phrase Card
struct DailyPhraseCard: View {
    let item: PracticeItem
    let onSpeak: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Phrase of the Day", systemImage: "star.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.orange)
                Spacer()
                Button(action: onSpeak) {
                    Image(systemName: "speaker.wave.2")
                        .foregroundColor(Color.compatIndigo)
                }
                .accessibilityLabel("Listen to phrase")
            }

            Text(item.sanskrit)
                .font(.title2.weight(.bold))

            Text(item.transliteration)
                .font(.subheadline)
                .italic()
                .foregroundColor(.secondary)

            Divider()

            HStack {
                VStack(alignment: .leading) {
                    Text(item.english)
                        .font(.subheadline)
                    Text(item.hindi)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                DifficultyBadge(level: item.difficulty)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
        .padding(.horizontal)
    }
}

// MARK: - Categories Grid
struct CategoriesGrid: View {
    @ObservedObject var vm: PracticeViewModel

    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose a Topic")
                .font(.headline)
                .padding(.horizontal)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(PracticeCategory.allCases) { category in
                    CategoryCard(category: category) {
                        vm.loadCategory(category)
                        withAnimation {
                            vm.mode = .flashcards
                        }
                    }
                }
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                Text("Test Yourself")
                    .font(.headline)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(PracticeCategory.allCases) { category in
                            Button {
                                vm.loadCategory(category)
                                vm.startQuiz(category: category)
                            } label: {
                                Label(category.rawValue, systemImage: "questionmark.circle")
                                    .font(.caption.weight(.medium))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.compatIndigo.opacity(0.1))
                                    .foregroundColor(Color.compatIndigo)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct CategoryCard: View {
    let category: PracticeCategory
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(Color.compatIndigo)
                Text(category.rawValue)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

// MARK: - Flashcard View
struct FlashcardView: View {
    @ObservedObject var vm: PracticeViewModel

    var body: some View {
        VStack(spacing: 16) {
            if let category = vm.selectedCategory {
                Text(category.rawValue)
                    .font(.headline)
            }

            if !vm.currentItems.isEmpty {
                let safeIndex = min(vm.flashcardIndex, vm.currentItems.count - 1)
                let item = vm.currentItems[safeIndex]

                VStack(spacing: 16) {
                    Text(item.english)
                        .font(.title3)
                        .multilineTextAlignment(.center)

                    Text(item.hindi)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    if vm.showFlashcardAnswer {
                        Divider()

                        Text(item.sanskrit)
                            .font(.title.weight(.bold))
                            .foregroundColor(Color.compatIndigo)

                        Text(item.transliteration)
                            .font(.subheadline)
                            .italic()
                            .foregroundColor(.secondary)

                        if let note = item.grammarNote {
                            Text(note)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 4)
                        }

                        Button {
                            vm.speak(text: item.sanskrit, language: .sanskrit, transliteration: item.transliteration)
                        } label: {
                            Label("Listen", systemImage: "speaker.wave.2")
                                .font(.caption)
                        }
                    }
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(Color(NSColor.controlBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
                .padding(.horizontal)
                .onTapGesture {
                    withAnimationRespectingReduceMotion(.spring()) {
                        vm.showFlashcardAnswer.toggle()
                    }
                }

                Text("Tap card to \(vm.showFlashcardAnswer ? "hide" : "reveal") answer")
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack(spacing: 20) {
                    Button(action: { vm.previousFlashcard() }) {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.title)
                    }
                    .disabled(vm.currentItems.count <= 1)
                    .accessibilityLabel("Previous flashcard")

                    Text("\(safeIndex + 1) / \(vm.currentItems.count)")
                        .font(.subheadline.weight(.medium))
                        .accessibilityLabel("Card \(safeIndex + 1) of \(vm.currentItems.count)")

                    Button(action: { vm.nextFlashcard() }) {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.title)
                    }
                    .disabled(vm.currentItems.count <= 1)
                    .accessibilityLabel("Next flashcard")
                }
                .foregroundColor(Color.compatIndigo)
            } else {
                EmptyStateView(
                    icon: "rectangle.on.rectangle.slash",
                    title: "No Items",
                    subtitle: "No vocabulary found for this topic."
                )
            }
        }
    }
}

// MARK: - Quiz View
struct QuizView: View {
    @ObservedObject var vm: PracticeViewModel
    @EnvironmentObject var dataStore: DataStore

    var body: some View {
        VStack(spacing: 20) {
            if let item = vm.quizItem {
                Text("Translate to Sanskrit:")
                    .font(.headline)

                Text(item.english)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()

                Text(item.hindi)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                TextField("Type Sanskrit or transliteration...", text: $vm.quizAnswer)
                    .textFieldStyle(.roundedBorder)
                    .font(.body)
                    .padding(.horizontal)

                Button("Check Answer") {
                    vm.checkAnswer(dataStore: dataStore)
                }
                .disabled(vm.quizAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                if let result = vm.quizResult {
                    switch result {
                    case .correct:
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Correct!")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                        .padding()

                    case .incorrect(let correct):
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                Text("Not quite.")
                                    .font(.headline)
                                    .foregroundColor(.red)
                            }
                            Text("The answer is: \(correct)")
                                .font(.subheadline)
                        }
                        .padding()
                    }

                    Button("Next Question") {
                        vm.nextQuizQuestion()
                    }
                }
            } else {
                EmptyStateView(
                    icon: "questionmark.circle",
                    title: "No Questions",
                    subtitle: "Select a topic first to start a quiz."
                )
            }
        }
        .padding(.horizontal)
    }
}
