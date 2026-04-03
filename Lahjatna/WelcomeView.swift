//
//  WelcomeView.swift
//  lahjtna
//
//  Created by Marwan Ameen Budair on 23/09/2025.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()

                VStack(spacing: 5) {
                    Text("Welcome to...")
                        .font(.title2)
                        .fontWeight(.medium)

                    Text("Lahjtna!")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("لهجتنا")
                        .font(.title2)
                }
                Text("First... What language do you speak?")
                    .font(.body)
                    .padding(.top, 20)

                VStack(spacing: 15) {
                    NavigationLink(destination: ArabicIntroView().navigationBarBackButtonHidden(true)) {
                        Text("عربي")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.teal)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                    }

                    Text("or...")
                        .font(.subheadline)

                    NavigationLink(destination: EnglishIntroView().navigationBarBackButtonHidden(true)) {
                        Text("English")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                    }
                }
                .padding(.horizontal, 40)

                Spacer()

                HStack {
                    Text("Already a user?")
                        .foregroundColor(.gray)
                    NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                        Text("Log in")
                            .fontWeight(.semibold)
                    }
                }
                .font(.footnote)
            }
            .padding()
        }
    }
}

#Preview {
    WelcomeView()
}
