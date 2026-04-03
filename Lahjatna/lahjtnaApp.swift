//
//  lahjtnaApp.swift
//  lahjtna
//
//  Created by Marwan Ameen Budair on 14/09/2025.
//

import SwiftUI
import FirebaseCore
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
          print("✅ Found GoogleService-Info.plist at: \(path)")
      } else {
          print("❌ GoogleService-Info.plist not found in bundle")
      }
    FirebaseApp.configure()

    return true
  }
}



@main
struct lahjtnaApp: App {
    
@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    var body: some Scene {
        WindowGroup {
            LoadingScreen()
        }
    }
}

