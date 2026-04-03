//
//  EnglishIntroView.swift
//  lahjtna
//
//  Created by Marwan Ameen Budair on 23/09/2025.
//

import SwiftUI

struct EnglishIntroView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Spacer()
                
                VStack(spacing: 6) {
                    Text("Welcome to...")
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    Text("Lahjtna!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("لهجتنا")
                        .font(.title2)
                }
                
                VStack(spacing: 8) {
                    Text("Not only you will learn Arabic, you will also learn Emirati dialect!")
                        .multilineTextAlignment(.center)
                        .font(.body)
                    
                    Text("Learning from this app will make you talk like a real Emirati!")
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                NavigationLink(destination: SignUpView().navigationBarBackButtonHidden(true)) {
                    Text("Start learning!")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 50)
                
                Spacer()
            }
            .padding()
        }
    }
}


#Preview {
    EnglishIntroView()
}
