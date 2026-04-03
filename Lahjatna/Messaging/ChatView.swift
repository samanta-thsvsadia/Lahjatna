
//
//  lahjatnaStructs.swift
//  Lahjatna
//
//  Created by Sadia Thasina on 01/10/2025.
//

import SwiftUI

struct ChatView: View {
    let chatId: String
    @State private var messages: [ChatMessage] = []
    @State private var text: String = ""

    var body: some View {
        VStack {
            if chatId.isEmpty {
                ProgressView("Creating Chat Path...")
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(messages) { msg in
                            Text(msg.text)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                }
                HStack {
                    TextField("Message...", text: $text)
                        .textFieldStyle(.roundedBorder)
                    Button("Send") {
                        ChatService.shared.sendMessage(chatId: chatId, text: text)
                        text = ""
                    }
                }.padding()
            }
        }
        .onAppear {
            print("DEBUG: 📱 ChatView Appeared with ID: \(chatId)")
            ChatService.shared.listenForMessages(chatId: chatId) { self.messages = $0 }
        }
    }
}
