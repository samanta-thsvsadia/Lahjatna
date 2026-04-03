//
//  LoginView.swift
//  lahjtna
//
//  Created by Marwan Ameen Budair on 24/09/2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var navigateToMainTab = false
    @State private var navigateToSignUp = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
            Spacer()
            
           
            Text("For free, join now and\nstart learning")
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 20) {
                
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
                    
                    
                    Button(action: {
                        print("Forgot password tapped")
                    }) {
                        Text("Forgot Password ?")
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                    .padding(.top, 2)
                }
            }
            .padding(.horizontal, 30)
            
            
            Button(action: {
                loginUser()
            }) {
                Text("Login")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "D4AF37"))
                    .foregroundColor(.black)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 50)
            .padding(.top, 10)
                
                Button(action: {
                    navigateToMainTab = true
                }) {
                    Text("Developer Mode")
                        .font(.headline)
                        .frame()
                        .padding()
                        .background(.teal)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 1)
                .padding(.top, 1)
            
            
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
            
           
            HStack(spacing: 0) {
                Button(action: {
                    print("Facebook login tapped")
                }) {
                    Image("facebook_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 50)
                }
                
                Button(action: {
                    print("Google login tapped")
                }) {
                    Image("google_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 50)
                }
            }
            
            Spacer()
            
            
            HStack {
                Text("Not a member?")
                    .foregroundColor(.gray)
                Button("Signup") {
                    navigateToSignUp = true
                }
                .foregroundColor(.blue)
                .fontWeight(.semibold)
            }
            .font(.footnote)
        }
        .padding()
        .navigationDestination(isPresented: $navigateToMainTab) {
            MainTabView()
                .navigationBarBackButtonHidden(true)
        }
        .navigationDestination(isPresented: $navigateToSignUp) {
            SignUpView()
                .navigationBarBackButtonHidden(true)
        }
    }
    }
    
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                return
            }
            
            guard let userId = result?.user.uid else { return }
            
            fetchUser(userId: userId) { user in
                if let user = user {
                    print("User fetched: \(user.username)")
                    navigateToMainTab = true
                } else {
                    print("User data not found")
                }
            }
        }
    }
}

import FirebaseFirestore

private let db = Firestore.firestore()

func fetchUser(userId: String, completion: @escaping (UserProfile?) -> Void) {
    db.collection("users").document(userId).getDocument { snapshot, error in
        if let data = snapshot?.data() {
            let user = UserProfile(
                id: snapshot!.documentID,
                username: data["username"] as? String ?? "",
                name: data["name"] as? String ?? "",
                email: data["email"] as? String ?? "",
                passwrod: data["password"] as? String ?? "",
                xp: data["xp"] as? Int ?? 0,
                streak: data["streak"] as? Int ?? 0,
                completedLessons: data["completedLessons"] as? [String] ?? [],
                lastActive: (data["lastActive"] as? Timestamp)?.dateValue() ?? Date(),
                country: data["country"] as? String ?? "",
                hobby: data["hobby"] as? String ?? ""
            )
            completion(user)
        } else {
            completion(nil)
        }
    }
}

#Preview {
    LoginView()
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
