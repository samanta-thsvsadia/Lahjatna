//
//  HomeView.swift
//  lahjtna
//
//  Created by Marwan Ameen Budair on 25/09/2025.
//

import SwiftUI

let lessons = [
    ("Lesson 1", "lesson1"),
    ("Lesson 2", "lesson2"),
    ("Lesson 3", "lesson3")
]


struct HomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack(alignment: .topTrailing) {
                Color(.white)
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 160)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.gray)
                                )
                            
                            VStack(alignment: .leading) {
                                Text("Welcome, User!")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                Text("What would you like to learn today?")
                                    .font(.subheadline)
                                    .foregroundColor(.black.opacity(0.9))
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 60)
                
                HStack(spacing: 16) {
                    Button {
                        
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell")
                                .font(.title3)
                                .foregroundColor(.black)
                            Circle()
                                .fill(Color.red)
                                .frame(width: 14, height: 14)
                                .overlay(
                                    Text("1")
                                        .foregroundColor(.black)
                                        .font(.system(size: 10))
                                )
                                .offset(x: 8, y: -8)
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                }
                .padding(.top, 70)
                .padding(.trailing, 20)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    NavigationLink(destination: RecentCoursesScreen()) {
                        HStack {
                            Text("Recent courses")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Text("→")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                    }
                    
                    HStack(spacing: 16) {
                        NavigationLink(destination: LessonView(lessonId: "lesson1")) {
                            CourseCard(title: "How to greet people the proper way!", icon: "person.wave.2")
                        }
                        NavigationLink(destination: RecentCoursesScreen()) {
                            CourseCard(title: "Basics on having a conversation", icon: "ellipsis.bubble")
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fun fact of the day:")
                            .font(.headline)
                            .foregroundColor(.green)
                        Text("UAE’s southern coast played a crucial role in the ancient frankincense trade, which flourished from the 1st century BCE to the 3rd century CE!")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
                    .padding(.horizontal)
                    
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Gaming mode")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(20)
                        .shadow(radius: 2)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 16)
                .padding(.bottom, 60)
            }
            
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(
                LinearGradient(
                    gradient: Gradient(stops: [
                        Gradient.Stop(color: Color(hex: "800000"), location: 0.3),
                        Gradient.Stop(color: Color(hex: "E1A504"), location: 1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all)
            )
        }
    }
}


struct CourseCard: View {
    let title: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.black)
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Text(title)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
        }
        .padding()
        .frame(width: 160, height: 180)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}


#Preview {
    HomeView()
}

