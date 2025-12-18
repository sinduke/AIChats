//
//  AsyncCallToActionButton.swift
//  AIChats
//
//  Created by sinduke on 12/18/25.
//

import SwiftUI

struct AsyncCallToActionButton: View {
    var isLoading: Bool = false
    var title: String = "Finished"
    var action: () -> Void
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
                    .tint(.white)
            } else {
                Text("Finished")
            }
        }
        .callToActionButton()
        .anyButton(.pressable) {
            action()
        }
        .disabled(isLoading)
    }
}

private struct ActionButtonPreviewView: View {
    @State private var isLoading: Bool = false
    var body: some View {
        AsyncCallToActionButton(isLoading: isLoading, title: "save") {
            isLoading = true
            Task {
                try? await Task.sleep(for: .seconds(3))
                isLoading = false
            }
        }
    }
}

#Preview {
    ActionButtonPreviewView()
        .padding(.horizontal)
}
