
//
//  lahjatnaStructs.swift
//  Lahjatna
//
//  Created by Sadia Thasina on 01/10/2025.
//


import FirebaseFirestore
import FirebaseAuth

class ChatService {
    static let shared = ChatService()
    private let db = Firestore.firestore()
    
    func getOrCreateChat(otherUserId: String, completion: @escaping (String) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("DEBUG: ❌ No logged in user found.")
            return
        }

        print("DEBUG: 🔍 Checking for existing chat with user: \(otherUserId)")
        
        db.collection("chats")
            .whereField("participants", arrayContains: currentUserId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("DEBUG: ❌ Error fetching chats: \(error.localizedDescription)")
                    return
                }

                if let docs = snapshot?.documents {
                    for doc in docs {
                        let participants = doc["participants"] as? [String] ?? []
                        if participants.contains(otherUserId) {
                            print("DEBUG: ✅ Found existing chat ID: \(doc.documentID)")
                            completion(doc.documentID)
                            return
                        }
                    }
                }

                print("DEBUG: 🆕 No chat found. Creating a new one...")
                let newChatRef = self.db.collection("chats").document()
                let data: [String: Any] = [
                    "participants": [currentUserId, otherUserId],
                    "lastMessage": "",
                    "lastTimestamp": Timestamp()
                ]
                
                newChatRef.setData(data) { error in
                    if let error = error {
                        print("DEBUG: ❌ Error creating chat: \(error.localizedDescription)")
                    } else {
                        print("DEBUG: ✅ Created new chat with ID: \(newChatRef.documentID)")
                        completion(newChatRef.documentID)
                    }
                }
            }
    }

    func listenForMessages(chatId: String, completion: @escaping ([ChatMessage]) -> Void) {
        guard !chatId.isEmpty else {
            print("DEBUG: ⚠️ listenForMessages called with EMPTY ID. Blocking to prevent crash.")
            return
        }
        
        print("DEBUG: 👂 Listening for messages in Chat: \(chatId)")
        db.collection("chats").document(chatId).collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("DEBUG: ❌ Listener error: \(error.localizedDescription)")
                    return
                }
                
                let messages = snapshot?.documents.compactMap { doc -> ChatMessage? in
                    let data = doc.data()
                    return ChatMessage(
                        id: doc.documentID,
                        senderId: data["senderId"] as? String ?? "",
                        text: data["text"] as? String ?? "",
                        timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    )
                } ?? []
                print("DEBUG: 📩 Received \(messages.count) messages.")
                completion(messages)
            }
    }

    func sendMessage(chatId: String, text: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid, !text.isEmpty else { return }
        print("DEBUG: 📤 Sending message to \(chatId)...")
        
        let data: [String: Any] = [
            "senderId": currentUserId,
            "text": text,
            "timestamp": Timestamp()
        ]

        db.collection("chats").document(chatId).collection("messages").addDocument(data: data)
        db.collection("chats").document(chatId).updateData([
            "lastMessage": text,
            "lastTimestamp": Timestamp()
        ])
    }
}
