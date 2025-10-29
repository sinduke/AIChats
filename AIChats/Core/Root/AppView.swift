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
                ZStack {
                    Color.blue.ignoresSafeArea()
                    Text("Main App View with Tabbar")
                }
            } onboardingView: {
                ZStack {
                    Color.green.ignoresSafeArea()
                    Text("Onboarding View without Tabbar")
                }
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
