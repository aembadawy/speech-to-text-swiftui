//
//  SpeechToTextView.swift
//  speech-to-text-swiftui
//
//  Created by Aya on 17/05/2025.
//

import SwiftUI

struct SpeechToTextView: View {
    @State private var isRecording = false
    @State private var viewModel = SpeechRecognitionViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "waveform")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.blue)
            
            Text("Speechify")
                .font(.headline)
            
            ScrollView {
                Text(
                    viewModel.transcript.isEmpty ? "Transcripted speech will apear here..." : viewModel.transcript)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray)
                .cornerRadius(12)
            }
            
            Button(isRecording ? "Stop Recording" : "Start Recording") {
                isRecording.toggle()
                
                if isRecording {
                    viewModel.startRecognition()
                } else {
                    viewModel.stopRecognition()
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(isRecording ? .red : .blue)
            .foregroundStyle(.white)
            .font(.headline)
            .cornerRadius(12)
            
        }
        .padding()
        
    }
}

#Preview {
    SpeechToTextView()
}
