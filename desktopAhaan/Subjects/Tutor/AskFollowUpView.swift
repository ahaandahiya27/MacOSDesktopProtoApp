import SwiftUI

/// Sheet that lets the kid ask any follow-up question about the current
/// concept. Backed by the on-device Apple Foundation Models. If the model
/// isn't available, the view degrades gracefully — instead of spinning
/// forever, it shows a friendly explanation of why and offers to save the
/// question for later.
struct AskFollowUpView: View {
    let pack: SubjectPack
    let concept: Concept

    @Environment(\.dismiss) private var dismiss
    @StateObject private var tutor = FoundationTutor()
    @State private var question: String = ""
    @State private var answer: String = ""
    @State private var error: String?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                // Status banner
                statusBanner

                // The kid's question
                VStack(alignment: .leading, spacing: 6) {
                    Text("Your question")
                        .font(.caption).foregroundStyle(.secondary).textCase(.uppercase)
                    TextField("e.g. Why is the sky blue?", text: $question, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(2...5)
                }

                // Submit
                HStack {
                    Spacer()
                    Button {
                        Task { await ask() }
                    } label: {
                        if tutor.isThinking {
                            ProgressView().controlSize(.small)
                        } else {
                            Label("Ask the tutor", systemImage: "sparkles")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!tutor.isAvailable || question.trimmingCharacters(in: .whitespaces).isEmpty || tutor.isThinking)
                }

                // Error
                if let error {
                    Label(error, systemImage: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.orange.opacity(0.10), in: RoundedRectangle(cornerRadius: 8))
                }

                // Answer
                if !answer.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Tutor's answer", systemImage: "graduationcap.fill")
                            .font(.caption.bold())
                            .foregroundStyle(.indigo)
                        ScrollView {
                            Text(answer)
                                .font(.body)
                                .lineSpacing(4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(12)
                        .background(.indigo.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
                    }
                }

                Spacer()
            }
            .padding(20)
            .frame(minWidth: 420, minHeight: 380)
            .navigationTitle("Ask about: \(concept.title)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var statusBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: tutor.isAvailable ? "checkmark.seal.fill" : "wifi.slash")
                .foregroundStyle(tutor.isAvailable ? .green : .secondary)
            VStack(alignment: .leading, spacing: 2) {
                Text(tutor.isAvailable ? "On-device tutor ready" : "On-device tutor unavailable")
                    .font(.callout.weight(.semibold))
                Text(tutor.availability.userMessage)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                Task { await tutor.refreshAvailability() }
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            .buttonStyle(.borderless)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Actions

    private func ask() async {
        error = nil
        do {
            answer = try await tutor.askFollowUp(about: concept, in: pack, question: question)
        } catch {
            self.error = error.localizedDescription
        }
    }
}
