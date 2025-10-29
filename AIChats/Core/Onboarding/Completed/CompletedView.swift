//
//  CompletedView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct CompletedView: View {
    @Environment(AppState.self) private var appState
    var body: some View {
        NavigationStack {
            VStack {
                Text("Onboarding Completed View")
                    .frame(maxHeight: .infinity)
                Button {
                    onFinishedButtonTapped()
                } label: {
                    Text("Finished")
                        .callToActionButton()
                }
            }
            .padding(16)
        }
    }
    
    private func onFinishedButtonTapped() {
        appState.updateViewState(showTabbarView: true)
    }
    
}

#Preview {
    CompletedView()
        .environment(AppState(showTabbar: false))
}
