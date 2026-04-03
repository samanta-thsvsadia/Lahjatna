//
//  RecentCourses.swift
//  lahjtna
//
//  Created by Marwan Ameen Budair on 27/09/2025.
//

import SwiftUI

struct RecentCourse: Identifiable {
    let id = UUID()
    let title: String
    let lessons: String
    let systemImage: String
}

struct RecentCoursesScreen: View {
    let courses: [RecentCourse] = [
        RecentCourse(title: "How to greet people the proper way!",
                     lessons: "Lesson 1 - 3",
                     systemImage: "handshake"),
        
        RecentCourse(title: "Basics on having a conversation",
                     lessons: "Lesson 2 - 6",
                     systemImage: "ellipsis.bubble.fill"),
        
        RecentCourse(title: "Being an Emirati at the work industry",
                     lessons: "Lesson 3 - 9",
                     systemImage: "laptopcomputer")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(
                    gradient: Gradient(stops: [
                        Gradient.Stop(color: Color(hex: "800000"), location: 0.3),
                        Gradient.Stop(color: Color(hex: "E1A504"), location: 1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(courses) { course in
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(course.title)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    
                                    Text(course.lessons)
                                        .font(.subheadline)
                                        .foregroundColor(.black.opacity(0.8))
                                    
                                    NavigationLink(destination: Text("Course Details for \(course.title)")) {
                                        Text("Continue")
                                            .underline()
                                            .foregroundColor(.black)
                                            .font(.subheadline)
                                    }
                                }
                                Spacer()
                                
                                Image(systemName: course.systemImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
            
        }
    }
}

struct RecentCoursesScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecentCoursesScreen()
    }
}
