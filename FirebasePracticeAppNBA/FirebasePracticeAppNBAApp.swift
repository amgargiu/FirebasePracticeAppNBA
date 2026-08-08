//
//  FirebasePracticeAppNBAApp.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 7/27/26.
//

import SwiftUI
import Firebase

@main
struct FirebasePracticeAppNBAApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
//            RootView()
            ContentView()
        }
    }
}



class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        print("Configured Firebase!")
        
        return true
    }
}
