import SwiftUI
import SwiftData

struct PracticeScreen: View {
    @StateObject private var vm = PracticeViewModel()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Daily phrase
                if let phrase = vm.dailyPhrase {
                    DailyPhraseCard(item: phrase, onSpeak: {
                        vm.speak(text: phrase.sanskrit, language: .sanskrit, transliteration: phrase.transliteration)
                    })
                }

                // Mode selection
                switch vm.mode {
                case .categories:
                    CategoriesGrid(vm: vm)
                case .flashcards:
                    FlashcardView(vm: vm)
                case .quiz:
                    QuizView(vm: vm, modelContext: modelContext)
                }
            }
            .padding(.vertical)
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Practice")
        .toolbar {
            if vm.mode != .categories {
                ToolbarItem {
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
                    .foregroundStyle(.orange)
                Spacer()
                Button(action: onSpeak) {
                    Image(systemName: "speaker.wave.2")
                        .foregroundStyle(.indigo)
                }
            }

            Text(item.sanskrit)
                .font(.title2.weight(.bold))

            Text(item.transliteration)
                .font(.subheadline)
                .italic()
                .foregroundStyle(.secondary)

            Divider()

            HStack {
                VStack(alignment: .leading) {
                    Text(item.english)
                        .font(.subheadline)
                    Text(item.hindi)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                DifficultyBadge(level: item.difficulty)
            }
        }
        .padding()
        .background(.background)
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

            // Quiz section
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
                                    .background(.indigo.opacity(0.1))
                                    .foregroundStyle(.indigo)
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
                    .foregroundStyle(.indigo)
                Text(category.rawValue)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.ultraThinMaterial)
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
                // Safe index access
                let safeIndex = min(vm.flashcardIndex, vm.currentItems.count - 1)
                let item = vm.currentItems[safeIndex]

                // Flashcard
                VStack(spacing: 16) {
                    Text(item.english)
                        .font(.title3)
                        .multilineTextAlignment(.center)

                    Text(item.hindi)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if vm.showFlashcardAnswer {
                        Divider()

                        Text(item.sanskrit)
                            .font(.title.weight(.bold))
                            .foregroundStyle(.indigo)

                        Text(item.transliteration)
                            .font(.subheadline)
                            .italic()
                            .foregroundStyle(.secondary)

                        if let note = item.grammarNote {
                            Text(note)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.top, 4)
                        }

                        Button {
                            vm.speak(text: item.sanskrit, language: .sanskrit, transliteration: item.transliteration)
                        } label: {
                            Label("Listen", systemImage: "speaker.wave.2")
                                .font(.caption)
                        }
                        .buttonStyle(.bordered)
                        .tint(.indigo)
                    }
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
                .padding(.horizontal)
                .onTapGesture {
                    withAnimation(.spring()) {
                        vm.showFlashcardAnswer.toggle()
                    }
                }

                Text("Tap card to \(vm.showFlashcardAnswer ? "hide" : "reveal") answer")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                // Navigation
                HStack(spacing: 20) {
                    Button(action: vm.previousFlashcard) {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.title)
                    }
                    .disabled(vm.currentItems.count <= 1)

                    Text("\(safeIndex + 1) / \(vm.currentItems.count)")
                        .font(.subheadline.weight(.medium))

                    Button(action: vm.nextFlashcard) {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.title)
                    }
                    .disabled(vm.currentItems.count <= 1)
                }
                .foregroundStyle(.indigo)
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
    let modelContext: ModelContext
    @FocusState private var isAnswerFocused: Bool

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
                    .foregroundStyle(.secondary)

                TextField("Type Sanskrit or transliteration...", text: $vm.quizAnswer)
                    .textFieldStyle(.roundedBorder)
                    .font(.body)
                    .padding(.horizontal)
                    .focused($isAnswerFocused)
                    .onSubmit {
                        if !vm.quizAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            vm.checkAnswer(modelContext: modelContext)
                        }
                    }

                Button("Check Answer") {
                    isAnswerFocused = false
                    vm.checkAnswer(modelContext: modelContext)
                }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
                .disabled(vm.quizAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                if let result = vm.quizResult {
                    switch result {
                    case .correct:
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("Correct!")
                                .font(.headline)
                                .foregroundStyle(.green)
                        }
                        .padding()

                    case .incorrect(let correct):
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red)
                                Text("Not quite.")
                                    .font(.headline)
                                    .foregroundStyle(.red)
                            }
                            Text("The answer is: \(correct)")
                                .font(.subheadline)
                                .textSelection(.enabled)
                        }
                        .padding()
                    }

                    Button("Next Question") {
                        vm.nextQuizQuestion()
                        isAnswerFocused = true
                    }
                    .buttonStyle(.bordered)
                    .tint(.indigo)
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
        .onAppear {
            // Focus the answer field when quiz starts
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isAnswerFocused = true
            }
        }
    }
}
