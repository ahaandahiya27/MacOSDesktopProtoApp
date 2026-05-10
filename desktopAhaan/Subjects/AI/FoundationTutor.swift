import Foundation
import SwiftUI
import Combine
#if canImport(FoundationModels)
import FoundationModels
#endif

/// On-device tutor backed by Apple's `FoundationModels` framework
/// (introduced with macOS 26 / Apple Intelligence).
///
/// Why this exists:
///   • Zero cost. No API key. No cloud round-trip.
///   • Private — every prompt and answer stays on the user's iMac.
///   • The kid can ask follow-up questions about any concept in any subject
///     without their parent setting up an Anthropic / OpenAI account.
///
/// How it degrades when not available:
///   • If the Foundation Models SDK isn't present (Xcode SDK older than 26,
///     or running on macOS < 15.1), the service reports `isAvailable = false`
///     and the UI shows a friendly "Coming soon" message instead of crashing.
///   • The compile-time `#if canImport(FoundationModels)` guard means the
///     project still builds on older toolchains.
@MainActor
final class FoundationTutor: ObservableObject {

    enum Availability: Equatable {
        case available
        case unsupportedOSVersion
        case modelNotDownloaded
        case appleIntelligenceDisabled
        case sdkNotPresent
        case unknown(String)

        var userMessage: String {
            switch self {
            case .available:                  return "On-device AI tutor ready."
            case .unsupportedOSVersion:       return "Requires macOS 26.0 or later."
            case .modelNotDownloaded:         return "Apple Intelligence model not yet downloaded. Open System Settings → Apple Intelligence to download."
            case .appleIntelligenceDisabled:  return "Apple Intelligence is turned off. Enable it in System Settings."
            case .sdkNotPresent:              return "This build was compiled without Foundation Models support."
            case .unknown(let m):             return m
            }
        }
    }

    @Published private(set) var availability: Availability = .unknown("checking…")
    @Published private(set) var isThinking: Bool = false

    init() {
        Task { [weak self] in await self?.refreshAvailability() }
    }

    /// Re-checks whether the on-device model is usable. Call this after the
    /// user changes a setting in System Settings.
    func refreshAvailability() async {
        availability = Self.computeAvailability()
    }

    var isAvailable: Bool { availability == .available }

    // MARK: - Public ask API

    /// Ask the on-device model a follow-up question about a concept. Returns
    /// the answer text, or throws if the model is unavailable or errored.
    /// The system prompt is built from the concept's full context so the
    /// tutor stays on topic.
    func askFollowUp(about concept: Concept, in pack: SubjectPack, question: String) async throws -> String {
        guard isAvailable else {
            throw TutorError.unavailable(availability.userMessage)
        }

        let userQuestion = question.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userQuestion.isEmpty else {
            throw TutorError.emptyQuestion
        }

        isThinking = true
        defer { isThinking = false }

        let system = Self.buildSystemPrompt(for: concept, in: pack)
        return try await Self.runOnDeviceModel(systemPrompt: system, userPrompt: userQuestion)
    }

    enum TutorError: LocalizedError {
        case unavailable(String)
        case emptyQuestion
        case modelFailed(String)

        var errorDescription: String? {
            switch self {
            case .unavailable(let m): return m
            case .emptyQuestion:       return "Type a question first."
            case .modelFailed(let m):  return "On-device tutor: \(m)"
            }
        }
    }

    // MARK: - Prompt construction

    private static func buildSystemPrompt(for concept: Concept, in pack: SubjectPack) -> String {
        let kid = concept.explanation(at: .kidFriendly)
        let textbook = concept.explanation(at: .textbook)
        return """
        You are a kind, patient Class 7 \(pack.title.lowercased()) tutor.
        Answer the student in 3–5 sentences, in plain language.
        If a useful analogy from the kid-friendly explanation below fits, reuse it.
        Never say 'as a language model' or apologize for being an AI.
        If the question is off-topic, gently steer back.

        TOPIC: \(concept.title)
        KID-FRIENDLY: \(kid)
        TEXTBOOK: \(textbook)
        REASONING: \(concept.reasoning)
        """
    }

    // MARK: - Foundation Models bridge
    //
    // The bridge is split out into a static method that's gated by
    // #if canImport(FoundationModels). On toolchains/devices where the SDK
    // is missing, the function throws .unavailable so the caller can show a
    // graceful message — the project still builds.

    #if canImport(FoundationModels)
    private static func runOnDeviceModel(systemPrompt: String, userPrompt: String) async throws -> String {
        // Real implementation. Apple's `FoundationModels` framework exposes
        // a `LanguageModelSession` API. The exact symbols ship with macOS 26+
        // / Xcode 26+. Wrap the actual call with availability checks so older
        // toolchains can still typecheck this branch.
        if #available(macOS 26.0, *) {
            let session = LanguageModelSession(
                instructions: systemPrompt
            )
            let response = try await session.respond(to: userPrompt)
            return response.content
        } else {
            throw TutorError.unavailable("Requires macOS 26.0 or later.")
        }
    }
    #else
    private static func runOnDeviceModel(systemPrompt: String, userPrompt: String) async throws -> String {
        throw TutorError.unavailable("This build was compiled without FoundationModels SDK support.")
    }
    #endif

    private static func computeAvailability() -> Availability {
        #if canImport(FoundationModels)
        if #available(macOS 26.0, *) {
            return Self.queryFoundationModelAvailability()
        } else {
            return .unsupportedOSVersion
        }
        #else
        return .sdkNotPresent
        #endif
    }

    #if canImport(FoundationModels)
    @available(macOS 26.0, *)
    private static func queryFoundationModelAvailability() -> Availability {
        // Apple's framework exposes a `SystemLanguageModel` singleton with
        // an `availability` property. Mapping the status to our enum:
        let status = SystemLanguageModel.default.availability
        switch status {
        case .available:
            return .available
        case .unavailable(let reason):
            switch reason {
            case .deviceNotEligible:        return .unsupportedOSVersion
            case .appleIntelligenceNotEnabled: return .appleIntelligenceDisabled
            case .modelNotReady:            return .modelNotDownloaded
            @unknown default:               return .unknown("Unavailable for an unknown reason.")
            }
        @unknown default:
            return .unknown("Unknown availability state.")
        }
    }
    #endif
}

// MARK: - Compile-time SDK shims
//
// When the FoundationModels SDK isn't present (older Xcode), we still need
// the file above to typecheck. The block below provides minimal shims that
// only compile in the !canImport branch — they are NEVER reached at runtime
// because the public methods throw .unavailable in that branch.

#if !canImport(FoundationModels)
private struct LanguageModelSession {
    init(instructions: String) {}
    func respond(to prompt: String) async throws -> Response { fatalError("shim") }
    struct Response { var content: String }
}
private struct SystemLanguageModel {
    static let `default` = SystemLanguageModel()
    var availability: Availability { .unavailable(.modelNotReady) }
    enum Availability { case available; case unavailable(Reason) }
    enum Reason { case deviceNotEligible; case appleIntelligenceNotEnabled; case modelNotReady }
}
#endif
