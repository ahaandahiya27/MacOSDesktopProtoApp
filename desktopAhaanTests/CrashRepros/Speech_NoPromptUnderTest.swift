import Testing
import Foundation
@testable import desktopAhaan

// MARK: - Speech_NoPromptUnderTest (regression lock for C3)
//
// C3 was the SF Speech permission dialog popping mid-test-run because
// `SpeechRecognitionManager.requestPermissions()` fell through to
// `SFSpeechRecognizer.requestAuthorization` whenever the system status
// was `.notDetermined`. Fix in 25f712b / a296077 / 49a7790: the manager
// now early-returns when `XCTestConfigurationFilePath` is set (the env
// var XCTest injects into the host process for every test run).
//
// This test locks two invariants:
//   1. `XCTestConfigurationFilePath` is non-nil under the test run —
//      i.e. the gate the production code uses is actually present.
//      Without this precondition the C3 guard does nothing.
//   2. `requestPermissions()` is a synchronous no-op under XCTest:
//      `authorizationStatus` stays `.notDetermined` and `permissionsReady`
//      stays false immediately after the call, proving the early-return
//      path was taken rather than the SFSpeechRecognizer.requestAuthorization
//      path (which would either flip the status to a cached system value
//      or kick an async authorization request).
//
// If someone removes the early-return from `requestPermissions()`,
// invariant 2 fails: on a machine where the user has previously answered
// the Speech prompt the cached value mirrors into `authorizationStatus`
// and the test fails. On a fresh machine the OS dialog appears and the
// test hangs / times out. Either failure mode catches the regression.

@MainActor
struct Speech_NoPromptUnderTest {

    @Test func xctestConfigEnvIsSetForTestRuns() {
        let path = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"]
        #expect(path != nil,
                "XCTestConfigurationFilePath must be set during the test run for the C3 guard to gate Speech.framework. If this is nil, the production code's early-return won't fire and the SF Speech dialog can pop mid-test.")
    }

    @Test func requestPermissionsIsNoOpUnderXCTest() {
        // Precondition: the env var the guard uses must be set.
        #expect(ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil)

        let manager = SpeechRecognitionManager()

        // The construction site default for authorizationStatus is .notDetermined
        // by design (49a7790 — no eager SFSpeechRecognizer.authorizationStatus
        // read in the @Published default).
        #expect(manager.authorizationStatus == .notDetermined)
        #expect(manager.permissionsReady == false)

        // Call the C3-guarded entry. If the guard works, this is a
        // synchronous no-op.
        manager.requestPermissions()

        // Immediately after the call: no state has moved. If the early
        // return is removed, on a machine where Speech has been
        // previously authorized/denied/restricted, requestAuthorization's
        // cached read would mirror into authorizationStatus before this
        // assertion runs.
        #expect(manager.authorizationStatus == .notDetermined,
                "requestPermissions() must early-return under XCTest. If authorizationStatus has moved off .notDetermined, the C3 guard is broken.")
        #expect(manager.permissionsReady == false)
    }
}
