//
//  AIChatsApp.swift
//  AIChats
//
//  Created by sinduke on 10/28/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    
    // 这里的强制解包是安全的 是为了运行之前就发现问题 建议保留
    var authManager: AuthManager!
    var userManager: UserManager!
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        authManager = AuthManager(service: FirebaseAuthService())
        userManager = UserManager(services: ProductUserServiceContainer())
        
        return true
    }
}

@main
struct AIChatsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            AppView()
                .environment(delegate.authManager)
                .environment(delegate.userManager)
        }
    }
}
