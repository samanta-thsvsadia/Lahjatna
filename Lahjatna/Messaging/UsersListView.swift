
//
//  lahjatnaStructs.swift
//  Lahjatna
//
//  Created by Sadia Thasina on 01/10/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct UsersListView: View {
    @Environment(\.dismiss) var dismiss
    @State private var users: [UserProfile] = []
    var onUserSelected: (String) -> Void
    
    var body: some View {
        NavigationView {
            List(users) { user in
                Button {
                    onUserSelected(user.id)
                    dismiss()
                } label: {
                    Text(user.username)
                }
            }
            .navigationTitle("New Message")
            .onAppear(perform: fetchUsers)
        }
    }
    
    func fetchUsers() {
        print("DEBUG: 📥 Fetching all users from Firestore...")
        
        // 1. Use explicit completion handler to avoid the "FirestoreSource" error
        Firestore.firestore().collection("users").getDocuments(completion: { snapshot, error in
            if let error = error {
                print("DEBUG: ❌ Firestore Error: \(error.localizedDescription)")
                return
            }
            
           
            self.users = snapshot?.documents.compactMap { (doc) -> UserProfile? in
                let data = doc.data()
                let id = doc.documentID
                
           
                if id == Auth.auth().currentUser?.uid { return nil }
                
                return UserProfile(
                    id: id,
                    username: data["username"] as? String ?? "Unknown",
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    passwrod: data["password"] as? String ?? "",
                    xp: data["xp"] as? Int ?? 0,
                    streak: data["streak"] as? Int ?? 0,
                    completedLessons: data["completedLessons"] as? [String] ?? [],
                    lastActive: (data["lastActive"] as? Timestamp)?.dateValue() ?? Date(),
                    country: data["country"] as? String ?? "",
                    hobby: data["hobby"] as? String ?? ""
                )
            } ?? []
            
            print("DEBUG: ✅ Found \(self.users.count) other users.")
        })
    }
}
