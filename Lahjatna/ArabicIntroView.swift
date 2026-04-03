//
//  ArabicIntroView.swift
//  lahjtna
//
//  Created by Marwan Ameen Budair on 23/09/2025.
//
import SwiftUI
struct ArabicIntroView: View {
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
                    Text("لن تتعلم اللغة العربية فقط، بل ستتعلم اللهجة الإماراتية أيضًا!")
                        .multilineTextAlignment(.center)
                        .font(.body)
                    
                    Text("التعلم من هذا التطبيق سيجعلك تتحدث مثل الإماراتي الحقيقي!")
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                NavigationLink(destination: SignUpView().navigationBarBackButtonHidden(true)) {
                    Text("ابدأ التعلم!")
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
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}

#Preview {
    ArabicIntroView()
}
