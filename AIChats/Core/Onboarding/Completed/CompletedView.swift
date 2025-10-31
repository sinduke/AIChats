//
//  CompletedView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct CompletedView: View {
    @Environment(AppState.self) private var appState
    var selectedColor: Color = .accentColor
    @State private var isCompletedProfileSetup: Bool = false
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                Text("Setup Completed!")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(selectedColor)
                
                Text("You have successfully completed the onboarding process. Tap the button below to start using the app.")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }
            .frame(maxHeight: .infinity)
            .safeAreaInset(edge: .bottom, alignment: .center, content: {
                ctaButton
            })
            .padding(24)
        }
    }
    
    // MARK: -- Functions
    private func onFinishedButtonTapped() {
        isCompletedProfileSetup = true
        Task {
            try? await Task.sleep(for: .seconds(2))
            isCompletedProfileSetup = false
            appState.updateViewState(showTabbarView: true)
        }
    }
    
    // MARK: -- Views
    private var ctaButton: some View {
        Button {
            onFinishedButtonTapped()
        } label: {
            ZStack {
                if isCompletedProfileSetup {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Finished")
                }
            }
            .callToActionButton()
        }
        .disabled(isCompletedProfileSetup)
    }
    
}

#Preview {
    CompletedView(selectedColor: .mint)
        .environment(AppState(showTabbar: false))
}
