//
//  speech_to_text_swiftuiTests.swift
//  speech-to-text-swiftuiTests
//
//  Created by Aya on 17/05/2025.
//

import Testing
@testable import speech_to_text_swiftui

struct speech_to_text_swiftuiTests {
    
    @MainActor @Test func testInitialTranscriptIsEmpty() {
        let recognizer = SpeechRecognitionViewModel()
        #expect(recognizer.transcript == "")
    }
    
    @MainActor @Test func testTranscriptUpdates() {
        let recognizer = SpeechRecognitionViewModel()
        recognizer.transcript = "Hello world"
        #expect(recognizer.transcript == "Hello world")
    }
}
