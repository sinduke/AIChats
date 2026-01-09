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
    var dependencies: Dependencies!
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        dependencies = Dependencies()
        
        return true
    }
}

// @MainActor
struct Dependencies {
    let authManager: AuthManager
    let userManager: UserManager
    let aiManager: AIManager
    let avatarManager: AvatarManager
    
    init() {
        authManager = AuthManager(service: FirebaseAuthService())
        userManager = UserManager(services: ProductUserServiceContainer())
        aiManager = AIManager(service: OpenAIAIService())
        avatarManager = AvatarManager(service: FirebaseAvatarService(imageUploader: FirebaseImageUploadService()))
    }
}

@main
struct AIChatsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            AppView()
                .environment(delegate.dependencies.authManager)
                .environment(delegate.dependencies.userManager)
                .environment(delegate.dependencies.aiManager)
                .environment(delegate.dependencies.avatarManager)
        }
    }
}
