//
//  SpeechRecognitionViewModel.swift
//  speech-to-text-swiftui
//
//  Created by Aya on 17/05/2025.
//

import Foundation
import Speech
import AVFoundation

@Observable
@MainActor
class SpeechRecognitionViewModel {
    private let speechRecognition = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    var transcript: String = ""
    
    init () {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .denied, .notDetermined, .restricted:
                self.transcript = "Permission not sufficient!"
            case .authorized:
                self.transcript = ""
            default:
                self.transcript = "Unknown permission issue occured!"
            }
        }
        
        AVAudioApplication.requestRecordPermission { granted in
            if !granted {
                self.transcript = "Microphone permission denied"
            }
        }
    }
    
    func startRecognition() {
        self.transcript = ""
        try? startSession()
    }
    
    func stopRecognition() {
        self.transcript = ""
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    private func startSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .measurement, options: .duckOthers)
        try session.setActive(true, options: .notifyOthersOnDeactivation)
        
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request else { return }
        
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffur, _ in
            request.append(buffur)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        recognitionTask = speechRecognition?.recognitionTask(with: request) { result, error in
            if let result = result {
                self.transcript = result.bestTranscription.formattedString
            } else if let error = error {
                self.transcript = error.localizedDescription
            }
        }
    }
    
}
