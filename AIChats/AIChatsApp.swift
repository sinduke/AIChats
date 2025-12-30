//
//  AIChatsApp.swift
//  AIChats
//
//  Created by sinduke on 10/28/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

struct EnvironmentBuilderView<Content: View>: View {
    @ViewBuilder var content: () -> Content
    var body: some View {
        content()
            .environment(AuthManager(service: FirebaseAuthService()))
    }
}

@main
struct AIChatsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            EnvironmentBuilderView {
                AppView()
            }
        }
    }
}
