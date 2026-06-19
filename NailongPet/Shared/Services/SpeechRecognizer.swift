import Foundation
import Speech
import SwiftUI
import AVFoundation
import Combine

class SpeechRecognizer: ObservableObject {
    @Published var transcript: String = ""
    @Published var isListening: Bool = false
    
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    func startTranscribing() {
        SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    self?.beginAudioSession()
                } else {
                    print("Speech recognition not authorized.")
                }
            }
        }
    }
    
    private func beginAudioSession() {
        if audioEngine.isRunning {
            stopTranscribing()
            return
        }
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to setup audio session: \(error.localizedDescription)")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            self.isListening = true
            self.transcript = ""
            print("SpeechRecognizer: Audio engine started. Listening...")
        } catch {
            print("SpeechRecognizer: Audio Engine failed to start: \(error.localizedDescription)")
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            var isFinal = false
            
            if let result = result {
                self.transcript = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                // Ignore small errors, but if it stops we clean up.
                self.stopTranscribing()
            }
        }
    }
    
    func stopTranscribing() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionRequest?.endAudio()
        }
        
        recognitionTask?.cancel()
        
        self.recognitionRequest = nil
        self.recognitionTask = nil
        
        DispatchQueue.main.async {
            self.isListening = false
            self.transcript = ""
        }
        
        print("SpeechRecognizer: Stopped listening.")
    }
}
