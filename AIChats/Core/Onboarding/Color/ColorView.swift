//
//  ColorView.swift
//  AIChats
//
//  Created by sinduke on 10/30/25.
//

import SwiftUI

struct ColorView: View {
    @State private var selectedColor: Color?
    let profileColors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple,
        .pink, .gray, .brown, .cyan, .mint, .indigo
    ]
    var body: some View {
        ScrollView {
            colorGrid
                .padding(.horizontal, 24)
        }
        .safeAreaInset(edge: .bottom, alignment: .center, spacing: nil, content: {
            ZStack {
                if let selectedColor {
                    ctaButton
                        .transition(AnyTransition.opacity.combined(with: .move(edge: .bottom)))
                        .padding(24)
                        .background(.ultraThinMaterial)
                }
            }
        })
        .animation(.smooth, value: selectedColor)
    }
    
    private var ctaButton: some View {
        NavigationLink {
            CompletedView()
        } label: {
            Text("Continue")
                .callToActionButton()
        }
    }
    
    private var colorGrid: some View {
        LazyVGrid(
            columns: Array(repeating: .init(.flexible(), spacing: 16), count: 3),
            alignment: .center,
            spacing: 16,
            pinnedViews: .sectionHeaders) {
                Section {
                    ForEach(profileColors, id: \.self) { color in
                        Circle()
                            .fill(.accent)
                            .overlay(content: {
                                color
                                    .clipShape(.circle)
                                    .padding(selectedColor == color ? 10 : 0)
                            })
                            .onTapGesture {
                                selectedColor = color
                            }
                    }
                } header: {
                    Text("Select a profile color")
                        .font(.headline)
                }
            }
    }
}

#Preview {
    ColorView()
}
