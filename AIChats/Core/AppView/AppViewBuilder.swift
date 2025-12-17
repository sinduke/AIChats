//
//  AppViewBuilder.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct AppViewBuilder<TabbarView: View, OnboardingView: View>: View {
    var showTabbar: Bool = false
    @ViewBuilder var tabbarView: TabbarView
    @ViewBuilder var onboardingView: OnboardingView
    var body: some View {
        ZStack {
            if showTabbar {
                tabbarView
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
            } else {
                onboardingView
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)) )
            }
        }
        .animation(.smooth, value: showTabbar)
    }
}

private struct AppViewBuilderPreviewView: View {
    @State private var showTabbar: Bool = true
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

#Preview {
    AppViewBuilderPreviewView()
}
