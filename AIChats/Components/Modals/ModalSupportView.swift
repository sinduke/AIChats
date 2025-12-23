//
//  ModalSupportView.swift
//  AIChats
//
//  Created by sinduke on 12/23/25.
//

import SwiftUI

struct ModalSupportView<Content: View>: View {
    @Binding var showModal: Bool
    @ViewBuilder var content: Content
    var body: some View {
        ZStack {
            if showModal {
                Color.black.opacity(0.4).ignoresSafeArea()
                    .transition(AnyTransition(.opacity.animation(.smooth)))
                    .onTapGesture {
                        showModal = false
                    }
                    .zIndex(1)
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .zIndex(2)
            }
        }
        .zIndex(9999)
        .animation(.bouncy, value: showModal)
    }
}

extension View {
    func showModal(showModal: Binding<Bool>, @ViewBuilder content: () -> some View) -> some View {
        self
            .overlay {
                ModalSupportView(showModal: showModal) {
                    content()
                }
            }
    }
}

private struct ModalSupportViewPreviews: View {
    @State private var showModal: Bool = false
    var body: some View {
        Button("Click Me") {
            showModal = true
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .showModal(showModal: $showModal) {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .padding(40)
                .foregroundColor(.blue)
                .padding(.vertical, 100)
                .onTapGesture {
                    showModal = false
                }
                .transition(.slide)
        }
    }
}

#Preview {
    ModalSupportViewPreviews()
}
