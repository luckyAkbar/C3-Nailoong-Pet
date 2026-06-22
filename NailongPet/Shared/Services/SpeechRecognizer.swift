import Foundation
import Speech
import SwiftUI
import AVFoundation
import Combine

class SpeechRecognizer: ObservableObject {
    @Published var transcript: String = ""
    @Published var isListening: Bool = false
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "id-ID"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private var isIntentionallyStopped: Bool = false
    
    func startTranscribing() {
        isIntentionallyStopped = false
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
            guard granted else {
                print("Microphone permission denied.")
                return
            }
            
            SFSpeechRecognizer.requestAuthorization { authStatus in
                DispatchQueue.main.async {
                    if authStatus == .authorized {
                        self?.beginAudioSession()
                    } else {
                        print("Speech recognition not authorized.")
                    }
                }
            }
        }
    }
    
    private func beginAudioSession() {
        if audioEngine.isRunning {
            internalStop()
        }
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .mixWithOthers])
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
            DispatchQueue.main.async {
                self.isListening = true
                self.transcript = ""
            }
            print("SpeechRecognizer: Audio engine started. Listening...")
        } catch {
            print("SpeechRecognizer: Audio Engine failed to start: \(error.localizedDescription)")
            if !self.isIntentionallyStopped {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if !self.isIntentionallyStopped {
                        self.beginAudioSession()
                    }
                }
            }
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
                self.internalStop()
                
                if !self.isIntentionallyStopped {
                    // Auto-restart to keep listening continuously
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        if !self.isIntentionallyStopped {
                            self.beginAudioSession()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isListening = false
                        self.transcript = ""
                    }
                }
            }
        }
    }
    
    func stopTranscribing() {
        isIntentionallyStopped = true
        internalStop()
        DispatchQueue.main.async {
            self.isListening = false
            self.transcript = ""
        }
        print("SpeechRecognizer: Stopped listening.")
    }
    
    private func internalStop() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionRequest?.endAudio()
        }
        
        recognitionTask?.cancel()
        
        self.recognitionRequest = nil
        self.recognitionTask = nil
    }
}
