//
//  MainTabView.swift
//  lahjtna
//
//  Created by Marwan Ameen Budair on 25/09/2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            Group {
                switch selectedTab {
                case 0: HomeView()
                case 1: CoursesView()
                case 2: SocialView()
                case 3: ChatbotView()
                default: HomeView()
                }
            }
            .ignoresSafeArea()
            
            
            HStack {
                BottomTabButton(icon: "house.fill", title: "Home", isActive: selectedTab == 0) {
                    selectedTab = 0
                }
                BottomTabButton(icon: "book.fill", title: "Courses", isActive: selectedTab == 1) {
                    selectedTab = 1
                }
                BottomTabButton(icon: "person.3.fill", title: "Social", isActive: selectedTab == 2) {
                    selectedTab = 2
                }
                BottomTabButton(icon: "message.fill", title: "AI Chatbot", isActive: selectedTab == 3) {
                    selectedTab = 3
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color.black.opacity(0.8))
            .cornerRadius(35)
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
            .shadow(radius: 4)
        }
    }
}

struct BottomTabButton: View {
    let icon: String
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isActive ? .blue : .gray)
                Text(title)
                    .font(.caption)
                    .foregroundColor(isActive ? .blue : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    MainTabView()
}

