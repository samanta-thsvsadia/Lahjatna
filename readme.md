# Lahjatna 
### **Dialect-First Arabic Learning & Social Connectivity Platform**

[![Platform](https://img.shields.io/badge/Platform-iOS_16.0+-black?style=for-the-badge&logo=ios)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange?style=for-the-badge&logo=swift)](https://swift.org)
[![License](https://img.shields.io/badge/License-Proprietary-red?style=for-the-badge)](https://choosealicense.com/no-permission/)

**Lahjatna** is an application that focuses on specific arabic dialects to revolutionize the way people learn Arabic. It features a Speech-to-Text (STT) pipeline to provide pronunciation feedback, as well as a vibrant community feed and a chatbot for 24-hour language assistance.

Currently the application is being developed and tested specifically the Emirati Arabic Dialect.

---

## App Media
| Walkthrough | 
| :---: | 
| <img src="https://github.com/samanta-thsvsadia/Lahjatna/blob/main/Media/lahjatna%20demo.mp4" width="280" alt="Speech Recognition Demo"> |
| *Real-time Speech-to-Text feedback* |

---

| Gallery | 
| :---: | 
| <img src="https://github.com/samanta-thsvsadia/Lahjatna/blob/main/Media/Product.jpg" width="280" alt="Gallery"> |

---

## Backend Logic Overview 

Lahjatna utilizes a custom implementation of Apple’s Speech framework tailored for the nuances of Arabic phonetics:
* **Dialectal STT:** Configured with `Locale(identifier: "ar-sa")` and custom normalization logic to accurately process and validate Emirati Arabic speech patterns.
* **Audio Engine Management:** Leverages `AVAudioEngine` for high-fidelity audio capture and buffer-based recognition via `SFSpeechAudioBufferRecognitionRequest`.
* **Text Normalization:** Implements a specialized normalization engine to handle invisible Unicode control characters and diacritics, ensuring fair and accurate pronunciation scoring.

---
* **Pattern:** MVVM (Model-View-ViewModel) utilizing `@StateObject` and `ObservableObject` for real-time UI synchronization.
* **Backend:** Integrated with Firebase Firestore for dynamic lesson delivery, user progress tracking, and social data persistence.
* **AI Integration:** Features a dedicated `GeminiService` to provide an intelligent chatbot experience for instant translation and grammatical help.

---

### [Core Logic & Services](/lahjtna%20v3)
* **`LessonViewModel.swift`**: Manages the lesson lifecycle, fetching content from Firestore and tracking user progress through serialized `LessonPart` objects.
* **`GeminiService.swift`**: Powers the conversational AI agent, allowing users to ask questions about dialectal nuances.
* **`ChatService.swift`**: Handles real-time messaging logic, including chat creation and message listeners.

### [UI Components](/lahjtna%20v3/Tabs)
* **`LessonViews.swift`**: The primary learning interface featuring video playback and interactive microphone states for verbal practice.
* **`SocialView.swift`**: A community hub for users to connect, share progress, and engage in peer-to-peer learning.
* **`ChatbotView.swift`**: An integrated AI chat interface for on-the-go linguistic support.

---

#### 1. Speech Recognition Engine
The `LessonView` manages the complex lifecycle of the `AVAudioEngine` to provide instant feedback on the user's spoken Arabic.

```swift
private func startAudioEngine() {
    let audioSession = AVAudioSession.sharedInstance()
    do {
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
        print("❌ Failed to configure audio session")
        return
    }

    let request = SFSpeechAudioBufferRecognitionRequest()
    self.recognitionRequest = request
    // ... configures input node and starts recognition task
}
```

---
#### 2. Text Normalization

To ensure the comparison between user speech and the correct answer is accurate, custom normalization is used to strip invisible formatting characters common in RTL (Right-to-Left) text.

```swift
private func normalizeArabicText(_ text: String) -> String {
    var cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
    // Remove invisible RTL control characters
    let invisibleChars: [Character] = ["\u{200E}", "\u{200F}", "\u{202B}", "\u{202C}"]
    cleaned.removeAll { invisibleChars.contains($0) }
    return cleaned

}
```
---
## Meet the Team
---

| Name | Role | Focus |
| :--- | :--- | :--- |
| **Yousif** | UX/UI Designer | User Experience Design, Prototyping & Visual Interface |
| **Marwan** | Frontend Engineer |  Core UI Development, SwiftUI Implementation |
| **Sadia** | Backend Engineer | Speech-to-Text Pipeline, Core System Logic |

---
## Security & Copyright
**Copyright © 2026 Sadia Thasina Samanta. All rights reserved.**

This repository is for **portfolio review purposes only**. No part of this program may be redistributed or used for commercial purposes.

---
**Developer:** sam.thsv7@gmail.com | https://www.linkedin.com/in/sadia-thasina-8392a637b
