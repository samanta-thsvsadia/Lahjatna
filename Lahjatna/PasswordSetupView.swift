//
//  PasswordSetupView.swift
//  lahjtna
//
//  Created by Marwan Ameen Budair on 23/09/2025.
//

import SwiftUI

struct PasswordSetupView: View {
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            
            Text("Choose a Password")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Password")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        if showPassword {
                            TextField("Enter your password", text: $password)
                                .autocapitalization(.none)
                                .padding()
                        } else {
                            SecureField("Enter your password", text: $password)
                                .autocapitalization(.none)
                                .padding()
                        }
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Confirm Password")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        if showConfirmPassword {
                            TextField("Confirm your password", text: $confirmPassword)
                                .autocapitalization(.none)
                                .padding()
                        } else {
                            SecureField("Confirm your password", text: $confirmPassword)
                                .autocapitalization(.none)
                                .padding()
                        }
                        
                        Button(action: {
                            showConfirmPassword.toggle()
                        }) {
                            Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 30)
            
            
            Button(action: {
                if password == confirmPassword && !password.isEmpty {
                    print("Signup successful")
                } else {
                    print("Passwords do not match!")
                }
            }) {
                Text("Signup")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 50)
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    PasswordSetupView()
}
