
//
//  lahjatnaStructs.swift
//  Lahjatna
//
//  Created by Sadia Thasina on 01/10/2025.
//

import Foundation
import FirebaseFirestore
import Firebase


struct UserProfile: Identifiable {
    var id: String
    var username: String
    var name: String
    var email: String
    var passwrod: String
    var xp: Int
    var streak: Int
    var completedLessons: [String]
    var lastActive: Date
    var country: String
    var hobby: String
}
    
    
    struct LessonPart: Identifiable, Codable {
        var id: String
        var arabicText: String
        var romanisation: String
        var englishText: String
        var audioUrl: String
        var correctAnswer: String
        var feedbackCorrect: String
        var title: String
        var isCorrect: Bool
        var userAnswer: String
    }
    
    struct Lesson: Identifiable, Codable {
        var id: String
        var title: String
        var description: String
        var level: Int
        var order: Int
        var xpReward: Int
        var parts: [LessonPart]
    }


struct ChatMessage: Identifiable {
    let id: String
    let senderId: String
    let text: String
    let timestamp: Date
}

struct ChatPreview: Identifiable {
    let id: String
    let lastMessage: String
    let participants: [String]
    var otherUserName: String
}
