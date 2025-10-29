//
//  AppView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct AppView: View {
    @AppStorage("showTabbarView") var showTabbar: Bool = true
    var body: some View {
        AppViewBuilder(
            showTabbar: showTabbar) {
                TabbarView()
            } onboardingView: {
                WelcomeView()
            }
        .onTapGesture {
            showTabbar.toggle()
        }
    }
}

#Preview("Onboarding") {
    AppView(showTabbar: false)
}

#Preview("Tabbar") {
    AppView(showTabbar: true)
}
