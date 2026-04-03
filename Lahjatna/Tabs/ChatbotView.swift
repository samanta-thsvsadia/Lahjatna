
//
//  lahjatnaStructs.swift
//  Lahjatna
//
//  Created by Sadia Thasina on 01/10/2025.
//


import SwiftUI

// MARK: - Message Model
struct ChatBotMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

// MARK: - Chatbot View
struct ChatbotView: View {
    @State private var messageText: String = ""
    @State private var messages: [ChatBotMessage] = []
    @State private var isTyping: Bool = false
    
    private let gemini = GeminiService()
    
    var body: some View {
        NavigationView {
            ZStack {
                // ORIGINAL BACKGROUND GRADIENT
                LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.2), Color.green.opacity(0.2)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    ScrollViewReader { scrollView in
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(messages) { msg in
                                    HStack {
                                        if msg.isUser { Spacer() }
                                        
                                        Text(msg.text)
                                            .padding()
                                            .background(msg.isUser ? Color.blue.opacity(0.8) : Color.white.opacity(0.9))
                                            .foregroundColor(msg.isUser ? .white : .black)
                                            .cornerRadius(16)
                                            .frame(maxWidth: 250, alignment: msg.isUser ? .trailing : .leading)
                                        
                                        if !msg.isUser { Spacer() }
                                    }
                                    .id(msg.id)
                                }
                                
                                if isTyping {
                                    HStack {
                                        Text("lahjatnaAI is typing...")
                                            .italic()
                                            .padding()
                                            .background(Color.white.opacity(0.9))
                                            .cornerRadius(16)
                                        Spacer()
                                    }
                                }
                            }
                            .padding()
                        }
                        .onChange(of: messages.count) { _ in
                            if let last = messages.last {
                                withAnimation {
                                    scrollView.scrollTo(last.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                    
                    // Input Field
                    HStack {
                        TextField("Type a message...", text: $messageText)
                            .padding(12)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(20)
                        
                        Button(action: sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.blue)
                                .padding(10)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                }
            }
            .navigationBarTitle("LahjatnaBot", displayMode: .inline)
            .padding(.bottom, 70)

        }
    }
    
    // MARK: - Send Message
    private func sendMessage() {
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        // Add user message
        messages.append(ChatBotMessage(text: text, isUser: true))
        messageText = ""
        
        // Show typing
        isTyping = true
        
        gemini.sendMessage(text) { response in
            // Hide typing and add AI response
            isTyping = false
            messages.append(ChatBotMessage(text: response, isUser: false))
        }
    }
}


// MARK: - Preview
struct ChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotView()
    }
}
