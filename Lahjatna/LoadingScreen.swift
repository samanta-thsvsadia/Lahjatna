//
//  LoadingScreen.swift
//  lahjtna
//
//  Created by Marwan Ameen Budair on 27/09/2025.
//


import SwiftUI

struct LoadingScreen: View {
    @State private var moveUp = false
    @State private var showLoader = false
    @State private var navigate = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    Image("Image 1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    
                    Text("Lahjtna!")
                        .font(.title)
                        .italic()
                    
                    Text("لهجتنا!")
                        .font(.title2)
                        .bold()
                }
                .offset(y: moveUp ? 0 : 400)
                .animation(.easeOut(duration: 1.5), value: moveUp)
                
                Spacer()
                
                if showLoader {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .padding(.bottom, 40)
                }
            }
            .onAppear {
                withAnimation {
                    moveUp = true
                }
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showLoader = true
                }
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) {
                    navigate = true
                }
            }
            .navigationDestination(isPresented: $navigate) {
                WelcomeView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}
