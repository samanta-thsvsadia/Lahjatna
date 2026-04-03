
//
//  lahjatnaStructs.swift
//  Lahjatna
//
//  Created by Sadia Thasina on 01/10/2025.
//




import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct OnboardingView: View {
    @State private var currentStep = 0
    @State private var selectedOptions: [Int?] = Array(repeating: nil, count: 3)
    
    let name: String
    let username: String
    let email: String
    let password: String
    @State private var selectedCountry: String = ""
    @State private var selectedHobby: Int? = nil
    @State private var shouldNavigate = false
    
    let step1Options = ["For work", "For travel", "For study", "For family", "For fun"]
    let step2Options = ["5 min / day", "10 min / day", "15 min / day", "30 min / day"]
    let step3Options = ["Friend", "Social Media", "App Store", "Other"]

    // Country Options
    let countries = Locale.Region.isoRegions.map { Locale.current.localizedString(forRegionCode: $0.identifier) ?? $0.identifier }.sorted()

    let hobbies = ["Reading", "Sports", "Music", "Traveling", "Cooking"]

    
    let db = Firestore.firestore()
    
    func saveUser() {
        let userId = Auth.auth().currentUser?.uid ?? UUID().uuidString
        let data: [String: Any] = [
            "id": userId,
            "name": name,
            "username": username,
            "email": email,
            "password": password,
            "country": selectedCountry,
            "hobby": selectedHobby != nil ? hobbies[selectedHobby!] : ""
        ]
        db.collection("users").document(userId).setData(data) { error in
            if let error = error {
                print("Error saving user: \(error)")
            } else {
                print("User saved successfully")
            }
        }
    }



    
    func achievements() -> [String] {
        var list: [String] = []
        
        if let reason = selectedOptions[0] {
            switch step1Options[reason] {
            case "For work": list.append("Communicate confidently at work")
            case "For travel": list.append("Navigate smoothly during trips")
            case "For study": list.append("Understand Arabic study materials")
            case "For family": list.append("Connect with family in Arabic")
            case "For fun": list.append("Enjoy Arabic culture & entertainment")
            default: break
            }
        }
        
        if let target = selectedOptions[1] {
            switch step2Options[target] {
            case "5 min / day": list.append("Build consistency with short sessions")
            case "10 min / day": list.append("Make steady daily progress")
            case "15 min / day": list.append("Learn faster with focused practice")
            case "30 min / day": list.append("Master Arabic at an accelerated pace")
            default: break
            }
        }
        
        if let source = selectedOptions[2] {
            switch step3Options[source] {
            case "Friend": list.append("Learn alongside your friends")
            case "Social Media": list.append("Be part of a growing community")
            case "App Store": list.append("Benefit from trusted learning resources")
            case "Other": list.append("Personalized learning journey")
            default: break
            }
        }
        
        return list.isEmpty ? ["Complete the steps to see achievements"] : list
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $currentStep) {
                    
                    VStack(spacing: 32) {
                        Text("What is your nationality?")
                            .font(.title2).fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                        
                        Picker("Select your nationality", selection: $selectedCountry) {
                            ForEach(countries, id: \.self) { country in
                                Text(country).tag(country)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.lightGray))
                        .cornerRadius(16)
                        
                        Spacer()
                    }
                    .padding()
                    .tag(0)

                    VStack(spacing: 32) {
                        Text("What is your hobby?")
                            .font(.title2).fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                        
                        VStack(spacing: 16) {
                            ForEach(hobbies.indices, id: \.self) { idx in
                                Button(action: {
                                    selectedHobby = idx
                                }) {
                                    Text(hobbies[idx])
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(selectedHobby == idx ? Color(.darkGray) : Color(.lightGray))
                                        .cornerRadius(16)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .tag(1)

                    
                    VStack(spacing: 32) {
                        Text("What's the main reason to learn Arabic?")
                            .font(.title2).fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                        
                        VStack(spacing: 16) {
                            ForEach(step1Options.indices, id: \.self) { idx in
                                Button(action: {
                                    selectedOptions[0] = idx
                                }) {
                                    Text(step1Options[idx])
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(selectedOptions[0] == idx ? Color(.darkGray) : Color(.lightGray))
                                        .cornerRadius(16)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .tag(2)
                    
                    
                    VStack(spacing: 32) {
                        Text("What is your daily learning target?")
                            .font(.title2).fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                        
                        VStack(spacing: 16) {
                            ForEach(step2Options.indices, id: \.self) { idx in
                                Button(action: {
                                    selectedOptions[1] = idx
                                }) {
                                    Text(step2Options[idx])
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(selectedOptions[1] == idx ? Color(.darkGray) : Color(.lightGray))
                                        .cornerRadius(16)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .tag(3)
                    
                    
                    VStack(spacing: 32) {
                        Text("How did you know about Lahjtna?")
                            .font(.title2).fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                        
                        VStack(spacing: 16) {
                            ForEach(step3Options.indices, id: \.self) { idx in
                                Button(action: {
                                    selectedOptions[2] = idx
                                }) {
                                    Text(step3Options[idx])
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(selectedOptions[2] == idx ? Color(.darkGray) : Color(.lightGray))
                                        .cornerRadius(16)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .tag(4)
                    
                   
                    VStack(spacing: 32) {
                        Text("These are what you achieve when using the app..")
                            .font(.title2).fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                        
                        VStack(spacing: 16) {
                            ForEach(achievements(), id: \.self) { achievement in
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.orange)
                                    Text(achievement)
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .tag(5)
                    
                    
                    VStack(spacing: 32) {
                        Text("Congratulations!\nYou have created an account.")
                            .font(.title2).fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                        
                        Image(systemName: "checkmark.seal.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.red)
                            .frame(width: 120, height: 120)
                            .padding()
                        
//                        NavigationLink(destination: MainTabView().navigationBarBackButtonHidden(true)) {
//                            Text("Continue")
//                                .foregroundColor(.white)
//                                .font(.headline)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.red)
//                                .cornerRadius(16)
//                        }
//                        .padding(.horizontal, 24)
                        
//                        Button(action: {
//                           // saveUser()          // Save all the user data to Firestore
//                            shouldNavigate = true  // Trigger navigation after saving
//                        }) {
//                            Text("Continue")
//                                .foregroundColor(.white)
//                                .font(.headline)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.red)
//                                .cornerRadius(16)
//                        }
//                        .padding(.horizontal, 24)
//
//                        // Hidden NavigationLink for programmatic navigation
//                        NavigationLink(
//                            destination: MainTabView().navigationBarBackButtonHidden(true),
//                            isActive: $shouldNavigate
//                        ) {
//                            EmptyView()
//                        }

                        Button(action: {
                            // 1️⃣ Create Firebase Auth user
                            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                                if let error = error as NSError? {
                                    print("Error creating user: \(error), code: \(error.code), userInfo: \(error.userInfo)")
                                    return
                                }
                                
                                guard let userId = result?.user.uid else { return }
                                
                                let data: [String: Any] = [
                                    "id": userId,
                                    "name": name,
                                    "username": username,
                                    "email": email,
                                    "password": password,
                                    "country": selectedCountry,
                                    "hobby": selectedHobby != nil ? hobbies[selectedHobby!] : "",
                                    "lastActive": Timestamp(date: Date()),
                                    "streak": 1,
                                    "xp": 0,
                                    "completedLessons": ""
                                ]
                                
                                db.collection("users").document(userId).setData(data) { error in
                                    if let error = error {
                                        print("Error saving user data: \(error.localizedDescription)")
                                    } else {
                                        print("User successfully saved in Firestore")
                                        shouldNavigate = true
                                    }
                                }
                            }

                        }) {
                            Text("Continue")
                                .foregroundColor(.white)
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(16)
                        }
                        .padding(.horizontal, 24)

                        // Hidden NavigationLink for programmatic navigation
                        NavigationLink(
                            destination: MainTabView().navigationBarBackButtonHidden(true),
                            isActive: $shouldNavigate
                        ) {
                            EmptyView()
                        }

                        
                        Spacer()
                    }
                    .padding()
                    .tag(6)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                
//                if currentStep < 6 {
//                    Button(action: {
//                        withAnimation {
//                            currentStep += 1
//                        }
//                    }) {
//                        Text("Next")
//                            .foregroundColor(.white)
//                            .font(.headline)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.red)
//                            .cornerRadius(16)
//                    }
//                    .padding([.horizontal, .bottom], 24)
//                }
                if currentStep < 6 {
                    Button(action: {
                        withAnimation {
                            // Move to next page
                            currentStep += 1
                        }
                    }) {
                        Text("Next")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(16)
                    }
                    .padding([.horizontal, .bottom], 24)
                }
            }
            .background(Color.white.ignoresSafeArea())
        }
    }
}

#Preview {
    OnboardingView(name: "Test Name", username: "TestUser", email: "test@email.com", password: "123456")
}
