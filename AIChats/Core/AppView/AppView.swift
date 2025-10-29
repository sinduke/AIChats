//
//  AppView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct AppView: View {
    @State var appState: AppState = AppState()
    var body: some View {
        AppViewBuilder(
            showTabbar: appState.showTabbar) {
                TabbarView()
            } onboardingView: {
                WelcomeView()
            }
            .environment(appState)
    }
}

#Preview("Onboarding") {
    AppView(appState: AppState(showTabbar: false))
}

#Preview("Tabbar") {
    AppView(appState: AppState(showTabbar: true))
}
