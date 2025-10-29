//
//  View+EXT.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

extension View {
    
    func callToActionButton() -> some View {
        self
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.accent)
            .cornerRadius(16)
    }
    
    func tappableBackground() -> some View {
        self
            .background(Color.black.opacity(0.0001))
            .contentShape(Rectangle())
    }
    
    func tappableBackground(action: @escaping () -> Void) -> some View {
        self
            .padding(8) // ✅ 扩大可点区域
            .background(Color.black.opacity(0.0001)) // ✅ 可点背景
            .contentShape(Rectangle()) // ✅ 明确点击形状
            .onTapGesture(perform: action)
    }
    
}
