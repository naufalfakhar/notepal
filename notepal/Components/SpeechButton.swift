//
//  SpeechButton.swift
//  HabitDaily
//
//  Created by Hansen Yudistira on 10/07/24.
//

import SwiftUI

struct SpeechButton: View {
    var micIconSize: CGFloat = 80
    @State var isRecording: Bool
    @State var color: Color
    
    @Binding var speechText: String
    @Binding var localeIdentifier: String
    @Binding var habitName: String
    @Binding var contentBody: String
    
    @StateObject var speechRecognizer = SpeechRecognizer()
    
    public init(isRecording: Bool = false, 
                color: Color = .white,
                speechText: Binding<String>,
                localeIdentifier: Binding<String>,
                habitName: Binding<String>,
                contentBody: Binding<String>) {
        self.isRecording = isRecording
        self.color = color
        self._speechText = speechText
        self._localeIdentifier = localeIdentifier
        _speechRecognizer = StateObject(wrappedValue: SpeechRecognizer(localeIdentifier: localeIdentifier.wrappedValue))
        self._habitName = habitName
        self._contentBody = contentBody
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
                .frame(width: micIconSize, height: micIconSize)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .padding(6)
                        .opacity(isRecording ? 1 : 0)
                        .animation(isRecording ? .easeInOut.repeatForever() : .default, value: isRecording)
                )
            
            Image(systemName: "mic.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: micIconSize * 0.6, height: micIconSize * 0.6)
                .foregroundColor(.white)
                .opacity(isRecording ? 0.5 : 1)
                .rotationEffect(Angle(degrees: isRecording ? 0 : -20))
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)) {
                isRecording.toggle()
                if isRecording {
                    color = .blue
                    speechRecognizer.transcribe()
                } else {
                    color = .white
                    speechRecognizer.stopTranscribing()
                    speechText += speechRecognizer.transcript
                    print(speechText)
                    speechRecognizer.currentAudioLevel = 0
                }
            }
        }
        .onChange(of: localeIdentifier) { oldLocale, newLocale in
            speechRecognizer.updateRecognizerLocale(newLocale)
        }
    }
}

