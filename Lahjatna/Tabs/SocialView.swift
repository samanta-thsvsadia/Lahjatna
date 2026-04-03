
//
//  lahjatnaStructs.swift
//  Lahjatna
//
//  Created by Sadia Thasina on 01/10/2025.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct SocialView: View {
    @State private var chats: [ChatPreview] = []
    @State private var showingUserList = false
    @State private var selectedChatId: String? = nil
    @State private var navigateToChat = false

    var body: some View {
        NavigationView {
            List(chats) { chat in
                NavigationLink(destination: ChatView(chatId: chat.id)) {
                    VStack(alignment: .leading) {
                        Text("Chat ID: \(chat.id)").font(.caption).foregroundColor(.gray)
                        Text(chat.lastMessage.isEmpty ? "No messages" : chat.lastMessage)
                    }
                }
            }
            .navigationTitle("Social")
            .toolbar {
                Button { showingUserList = true } label: { Image(systemName: "plus.circle.fill") }
            }
            .sheet(isPresented: $showingUserList) {
                UsersListView { otherUserId in
                    print("DEBUG: 👤 User selected: \(otherUserId). Requesting chat ID...")
                    ChatService.shared.getOrCreateChat(otherUserId: otherUserId) { newId in
                        self.selectedChatId = newId
                        self.navigateToChat = true
                        print("DEBUG: 🚀 Navigation triggered for ID: \(newId)")
                    }
                }
            }
            .background(
                NavigationLink(
                    destination: ChatView(chatId: selectedChatId ?? ""),
                    isActive: $navigateToChat
                ) { EmptyView() }
            )
            .onAppear {
                fetchChatList()
            }
        }
    }

    func fetchChatList() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("chats")
            .whereField("participants", arrayContains: uid)
            .addSnapshotListener { snap, _ in
                self.chats = snap?.documents.compactMap { doc in
                    let data = doc.data()
                    return ChatPreview(
                        id: doc.documentID,
                        lastMessage: data["lastMessage"] as? String ?? "",
                        participants: data["participants"] as? [String] ?? [],
                        otherUserName: ""
                    )
                } ?? []
            }
    }
}
