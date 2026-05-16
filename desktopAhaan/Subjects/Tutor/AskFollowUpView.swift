import SwiftUI

/// Sheet that lets the kid ask any follow-up question about the current
/// concept. Backed by the on-device Apple Foundation Models. If the model
/// isn't available, the view degrades gracefully — instead of spinning
/// forever, it shows a friendly explanation of why and offers to save the
/// question for later.
struct AskFollowUpView: View {
    let pack: SubjectPack
    let concept: Concept

    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var tutor = FoundationTutor()
    @State private var question: String = ""
    @State private var answer: String = ""
    @State private var error: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
                // Status banner
                statusBanner

                // The kid's question
                VStack(alignment: .leading, spacing: 6) {
                    Text("Your question")
                        .font(.caption).foregroundColor(.secondary).textCase(.uppercase)
                    TextEditor(text: $question)
                        .frame(minHeight: 50, maxHeight: 100)
                        .font(.body)
                        .padding(4)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
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
                    
                    .disabled(!tutor.isAvailable || question.trimmingCharacters(in: .whitespaces).isEmpty || tutor.isThinking)
                }

                // Error
                if let error = error {
                    Label(error, systemImage: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 8).fill(.orange.opacity(0.10)))
                }

                // Answer
                if !answer.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Tutor's answer", systemImage: "graduationcap.fill")
                            .font(.caption.bold())
                            .foregroundColor(Color.compatIndigo)
                        ScrollView {
                            Text(answer)
                                .font(.body)
                                .lineSpacing(4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.compatIndigo.opacity(0.08)))
                    }
                }

                Spacer()
            }
            .padding(20)
            .frame(
                minWidth: 420, idealWidth: 600, maxWidth: 720,
                minHeight: 380, idealHeight: 600, maxHeight: 800
            )
            .overlay(
                HStack {
                    Spacer()
                    VStack {
                        Button("Close") { presentationMode.wrappedValue.dismiss() }
                            .padding(12)
                        Spacer()
                    }
                }
            )
    }

    // MARK: - Subviews

    @ViewBuilder
    private var statusBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: tutor.isAvailable ? "checkmark.seal.fill" : "wifi.slash")
                .foregroundColor(tutor.isAvailable ? .green : .secondary)
            VStack(alignment: .leading, spacing: 2) {
                Text(tutor.isAvailable ? "On-device tutor ready" : "On-device tutor unavailable")
                    .font(.callout.weight(.semibold))
                Text(tutor.availability.userMessage)
                    .font(.caption2)
                    .foregroundColor(.secondary)
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
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
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
