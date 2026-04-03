
//
//  LessonView.swift
//  lahjtna
//
//  Created by Sadia Thasina on 07/10/2025.
//

import SwiftUI
import AVKit
import FirebaseFirestore
import Speech

// MARK: - ViewModel
class LessonViewModel: ObservableObject {
    @Published var parts: [LessonPart] = []
    @Published var currentIndex: Int = 0

    private let db = Firestore.firestore()

    func loadLesson(lessonId: String) {
        print("🔹 Loading lesson:", lessonId)
        db.collection("lessons").document(lessonId).getDocument { snapshot, error in
            if let error = error {
                print("❌ Error fetching lesson:", error.localizedDescription)
                return
            }
            guard let data = snapshot?.data() else {
                print("❌ No data found in lesson")
                return
            }
            print("✅ Lesson data fetched:", data)
            if let contentArray = data["content"] as? [[String: Any]] {
                var loadedParts: [LessonPart] = []
                for partData in contentArray {
                    let part = LessonPart(
                        id: partData["id"] as? String ?? UUID().uuidString,
                        arabicText: partData["arabicText"] as? String ?? "",
                        romanisation: partData["romanisation"] as? String ?? "",
                        englishText: partData["englishText"] as? String ?? "",
                        audioUrl: partData["audioUrl"] as? String ?? "",
                        correctAnswer: partData["correctAnswer"] as? String ?? "",
                        feedbackCorrect: partData["feedbackCorrect"] as? String ?? "",
                        title: partData["Title"] as? String ?? "speech",
                        isCorrect: partData["isCorrect"] as? Bool ?? false,
                        userAnswer: partData["userAnswer"] as? String ?? ""
                    )
                    loadedParts.append(part)
                }
                DispatchQueue.main.async {
                    self.parts = loadedParts
                    self.currentIndex = 0
                    print("✅ Loaded \(loadedParts.count) parts. Current index = 0")
                }
            } else {
                print("❌ 'content' array not found or empty")
            }
        }
    }

    func nextPart() {
        if currentIndex < parts.count - 1 {
            currentIndex += 1
            print("➡️ Moved to next part, index =", currentIndex)
        } else {
            print("🎉 All parts completed!")
        }
    }

    var currentPart: LessonPart? {
        if parts.indices.contains(currentIndex) {
            return parts[currentIndex]
        }
        return nil
    }
}

// MARK: - LessonView
struct LessonView: View {
    let lessonId: String
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

    @StateObject var viewModel = LessonViewModel()
    @State private var player = AVPlayer()
    @State private var showSheet = false
    @State private var clearedPartText = ""
    @State private var goToHome = false
  

    // Speech recognition
    @State private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ar-sa"))
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var audioEngine = AVAudioEngine()
    @State private var recognizedText = ""

    // MARK: - Speech Functions
    func startListening() {
        print("🎤 Mic pressed. Starting authorization...")
        
        guard let recognizer = speechRecognizer else {
            print("❌ Speech recognizer is nil")
            return
        }
        
        if !recognizer.isAvailable {
            print("❌ Speech recognizer is not available")
            return
        }
        
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    print("✅ Speech recognition authorized")
                    self.startAudioEngine()
                case .denied:
                    print("❌ Authorization denied")
                case .restricted:
                    print("❌ Authorization restricted")
                case .notDetermined:
                    print("❌ Authorization not determined")
                @unknown default:
                    print("❌ Unknown authorization status")
                }
            }
        }
    }





    private func startAudioEngine() {
        print("🔹 Starting audio engine...")

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            print("✅ Audio session configured")
        } catch {
            print("❌ Failed to configure audio session:", error.localizedDescription)
            return
        }

        // Create ONE request and store it
        let request = SFSpeechAudioBufferRecognitionRequest()
        self.recognitionRequest = request
        request.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            request.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
            print("✅ Audio engine started")
        } catch {
            print("❌ Audio engine start failed:", error.localizedDescription)
            return
        }

        // ❌ REMOVE THIS — IT ERASES THE RESULT
        // recognitionTask?.cancel()

        recognizedText = ""

        recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
            if let result = result {
                self.recognizedText = result.bestTranscription.formattedString
                print("📝 Recognized:", self.recognizedText)

                if result.isFinal {
                    print("✅ Final recognized text:", self.recognizedText)
                    self.stopListening()
                }
            }

            if let error = error {
                print("❌ Speech recognition error:", error.localizedDescription)
                self.stopListening()
            }
        }
    }


    // --- Add this helper function somewhere in the struct ---
    private func normalizeArabicText(_ text: String) -> String {
        // Trim spaces and newlines
        var cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove common invisible/control characters
        let invisibleChars: [Character] = ["\u{200E}", "\u{200F}", "\u{202B}", "\u{202C}", "\u{2066}", "\u{2067}", "\u{2068}", "\u{2069}"]
        
        cleaned.removeAll { invisibleChars.contains($0) }
        
        return cleaned
    }





    
    func stopListening() {
        print("🔹 Requesting recognition to finish...")

        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)

        recognitionRequest?.endAudio()  
    }



    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let part = viewModel.currentPart {
                    // Top bar
                    HStack {
                        Button(action: {}) { Image(systemName: "xmark").font(.system(size: 18, weight: .bold)).foregroundColor(.black) }
                        ProgressView(value: 0.3).progressViewStyle(LinearProgressViewStyle(tint: .blue)).frame(height: 4).padding(.horizontal, 8)
                        Button(action: {}) { Image(systemName: "ellipsis").rotationEffect(.degrees(90)).foregroundColor(.black).font(.system(size: 20)) }
                    }
                    .padding(.horizontal)

                    // Title
                    Text(part.title).foregroundColor(Color(hex: "800000")).font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)

                    // Video Player
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(LinearGradient(colors: [Color(hex: "#800000"), Color(hex: "#E1A504")], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 6)
                                .frame(height: 250)
                            VideoPlayer(player: player).frame(height: 250).cornerRadius(12).onAppear {
                                if let url = URL(string: part.audioUrl) {
                                    player.replaceCurrentItem(with: AVPlayerItem(url: url))
                                }
                            }
                        }

                        HStack(spacing: 30) {
                            Button(action: {
                                player.seek(to: .zero) // Go back to the start
                                player.play()           // Then play
                            }) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                        LinearGradient(
                                            colors: [Color(hex: "#800000"), Color(hex: "#E1A504")],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .clipShape(Circle())
                            }
                         
                        }
                    }
                    .padding(.horizontal)

                    // Texts
                    VStack(spacing: 6) {
                        Text(part.arabicText).font(.title3).multilineTextAlignment(.center)
                        Text(part.romanisation).font(.title3).foregroundColor(.green).bold().multilineTextAlignment(.center)
                    }
                    .padding(.top, 10)

                    // --- Speech Recognition UI ---
                    VStack(spacing: 10) {
                        // MARK: - Mic Button Action
                        Button(action: {
                            if audioEngine.isRunning {
                                stopListening()
                            } else {
                                startListening()
                            }
                        }) {
                            Image(systemName: audioEngine.isRunning ? "stop.circle.fill" : "mic.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(audioEngine.isRunning ? .red : .green)
                        }

                        Text(recognizedText.isEmpty ? "Tap mic and speak..." : recognizedText)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                            .multilineTextAlignment(.center)
                        
                       
                    }

                    // Simulate correct answer
                    Button("Check") {
                        guard let part = viewModel.currentPart else { return }

                        let normalizedRecognized = normalizeArabicText(recognizedText)
                        let normalizedCorrect = normalizeArabicText(part.correctAnswer)

                        print("📝 Comparing recognized: '\(normalizedRecognized)' with correct: '\(normalizedCorrect)'")

                        if normalizedRecognized == normalizedCorrect {
                            clearedPartText = """
                                ✅ Correct!
                                
                                \(part.feedbackCorrect)
                                """
                            showSheet = true
                        } else {
                            print("❌ Try Again! Recognized: '\(normalizedRecognized)' | Correct: '\(normalizedCorrect)'")
                            clearedPartText = """
                            ❌ Try Again!

                            You said:
                            \(normalizedRecognized)

                            Correct answer:
                            \(normalizedCorrect)
                            """
                            
                        }
                        showSheet = true
                    }
                    .padding()
                    .background(Color.green.opacity(0.7))
                    .cornerRadius(12)
                    .foregroundColor(.white)

                } else {
                    ProgressView("Loading first part...")
                }

                NavigationLink(destination: HomeView(), isActive: $goToHome) { EmptyView() }
            }
            .padding(.top)
            .onAppear { viewModel.loadLesson(lessonId: lessonId) }
            .sheet(isPresented: $showSheet) {
                VStack(spacing: 20) {
                    Text(clearedPartText).font(.title2).multilineTextAlignment(.center).padding()
//                    Button("Next Part") {
//                        if clearedPartText != "Congratulations! You’ve completed the lesson." {
//                            viewModel.nextPart()
//                        } else {
//                            goToHome = true
//                        }
//                        showSheet = false
//                    }
                    Button(clearedPartText.contains("✅") ? "Next Part" : "Try Again") {
                        if clearedPartText.contains("✅") {
                            viewModel.nextPart()
                        }
                        showSheet = false
                    }
                    .padding()
                    .background(
                        clearedPartText.contains("✅")
                        ? Color.green.opacity(0.7)
                        : Color.yellow.opacity(0.8)
                    )
                    .cornerRadius(12)
                    .foregroundColor(clearedPartText.contains("✅") ? .white : .black)
                    .bold()
                }
                .padding()
            }
        }
    }
}

// MARK: - Preview
struct LessonView_Previews: PreviewProvider {
    static var previews: some View {
        LessonView(lessonId: "lesson1")
    }
}


