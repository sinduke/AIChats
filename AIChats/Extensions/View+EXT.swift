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
    
    func removeListRowFormatting() -> some View {
        self
//            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowInsets(EdgeInsets())
//            .listSectionMargins(.all, 0)
            .listRowBackground(Color.clear)
//            .listRowSeparator(.hidden)
    }
    
    func addingGradientBackgroundForText() -> some View {
        background(
            LinearGradient(colors: [
                .black.opacity(0.1),
                .black.opacity(0.3),
                .black.opacity(0.4)
            ], startPoint: .top, endPoint: .bottom)
        )
    }
    
}
