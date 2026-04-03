//
//  SignUpView.swift
//  lahjtna
//
//  Created by Marwan Ameen Budair on 24/09/2025.
//

import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToOnboarding = false
    @State private var navigateToLogin = false
    
    var body: some View {
        NavigationStack {
        VStack(spacing: 25) {
            Spacer()
            
           
            Text("Create an Account")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 15) {
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Name")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextField("Placeholder text", text: $name)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("username")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextField("Placeholder text", text: $username)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Email Address")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextField("Placeholder text", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Password")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextField("Placeholder text", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 30)
            
            
            Button(action: {
                navigateToOnboarding = true
               
            }) {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "D4AF37"))
                    .foregroundColor(.black)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)
            .padding(.top, 10)
            
            
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
                Text("Or")
                    .foregroundColor(.gray)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
            }
            .padding(.horizontal, 40)
            
            
            HStack(spacing: 20) {
                Image("facebook_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 50)
                Image("google_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 50)
            }
            
            Spacer()
            
            
            HStack {
                Text("Already a member?")
                    .foregroundColor(.gray)
                Button("Login") {
                    navigateToLogin = true
                }
                .foregroundColor(.blue)
                .fontWeight(.semibold)
            }
            .font(.footnote)
        }
        .padding()
        .navigationDestination(isPresented: $navigateToOnboarding) {
            OnboardingView(
                name: name,
                username: username,
                email: email,
                password: password
            )
                .navigationBarBackButtonHidden(true)
        }
        .navigationDestination(isPresented: $navigateToLogin) {
            LoginView()
                .navigationBarBackButtonHidden(true)
        }
        }
    }
}

#Preview {
    SignUpView()
}
