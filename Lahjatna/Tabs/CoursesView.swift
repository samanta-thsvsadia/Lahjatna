
//
//  lahjatnaStructs.swift
//  Lahjatna
//
//  Created by Sadia Thasina on 01/10/2025.
//



import SwiftUI
import FirebaseFirestore

struct CoursesView: View {
    @State private var searchText = ""
    @State private var lessons: [LessonCard] = [] // from Firebase
    
    var filteredLessons: [LessonCard] {
        if searchText.isEmpty { return lessons }
        return lessons.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color(hex: "D4AF37"), Color(hex: "F5EFE2")], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
                            // --- Header ---
                            HStack {
                                Text("What would you like to learn today, user?")
                                    .font(.title3).fontWeight(.bold)
                                Spacer()
                                Button { } label: {
                                    Image(systemName: "gearshape.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 50)
                            
                            Text("You can search for a specific lesson!")
                                .font(.subheadline)
                                .padding(.horizontal)
                            
                            // --- Search Bar ---
                            HStack {
                                TextField("Search", text: $searchText)
                                    .padding(12)
                                Button { } label: {
                                    Image(systemName: "mic.fill")
                                        .foregroundColor(.gray)
                                        .padding(12)
                                }
                            }
                            .background(Color(.systemGray6))
                            .cornerRadius(20)
                            .padding(.horizontal)
                            
                            // --- Grid ---
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 25) {
                                ForEach(filteredLessons) { lesson in
                                    LessonCardView(lesson: lesson)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 80)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
            }
            .onAppear {
                loadLessons()
            }
        }
    }
    
    // MARK: - Firebase Load
    func loadLessons() {
        Firestore.firestore().collection("lessons").order(by: "order").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching lessons:", error.localizedDescription)
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            lessons = documents.compactMap { doc in
                let data = doc.data()
                return LessonCard(
                    id: doc.documentID,
                    level: "Level \(data["level"] as? Int ?? 1)",
                    title: data["title"] as? String ?? "Untitled",
                    description: data["description"] as? String ?? "",
                    category: "Lesson",
                    imageName: "Grocery" // keep your existing card layout
                )
            }
        }
    }
}

// MARK: - Model
struct LessonCard: Identifiable {
    let id: String
    let level: String
    let title: String
    let description: String
    let category: String
    let imageName: String
}

// MARK: - Card View
struct LessonCardView: View {
    let lesson: LessonCard
    
    var body: some View {
        NavigationLink(destination: LessonView(lessonId: lesson.id)) {
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 150)
                        .frame(width: 150)
                        .cornerRadius(12)
                        .overlay(
                            Image(lesson.imageName)
                                .resizable()
                                .scaledToFill()
                                .cornerRadius(12)
                        )
                    
                    Text(lesson.level)
                        .font(.caption2)
                        .padding(6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(6)
                }
                
                Text(lesson.title)
                    .font(.headline)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                Text(lesson.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                Text(lesson.category)
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(17)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}
#Preview {
    CoursesView()
}


