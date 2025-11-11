//
//  ButtonViewModifiers.swift
//  AIChats
//
//  Created by sinduke on 11/10/25.
//

import SwiftUI

struct HighlightButtonStyle: ButtonStyle {
    var opacity: Double = 0.4
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(Color.black.opacity(configuration.isPressed ? opacity : 0))
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

struct PressableButtonStyle: ButtonStyle {
    var scale: Double = 0.95
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

enum ButtonStyleOption {
    case highlight(opacity: Double = 0.4)
    case pressable(scale: Double = 0.95)
    case plain
}

extension View {
    
    @ViewBuilder
    func anyButton(_ option: ButtonStyleOption = .plain, action: @escaping () -> Void) -> some View {
        // 统一 Button 构造，保证点击区域（含留白）都可点
        let content = Button(action: action) {
            self.contentShape(Rectangle())
        }
        
        switch option {
        case.highlight(let opacity):
            content.buttonStyle(HighlightButtonStyle(opacity: opacity))
        case .pressable(let scale):
            content.buttonStyle(PressableButtonStyle(scale: scale))
        case .plain:
            content.buttonStyle(PlainButtonStyle())
        }
    }
}

extension ButtonStyleOption {
    static let highlight: Self = .highlight()
    static let pressable: Self = .pressable()
}

#Preview {
    VStack {
        Text("Highlight-98")
            .callToActionButton()
            .tappableBackground()
            .anyButton(.highlight) {
                
            }
        
        Text("Highlight-5")
            .callToActionButton()
            .tappableBackground()
            .anyButton(.highlight(opacity: 0.5)) {
                
            }
        
        Text("PressableButton")
            .callToActionButton()
            .tappableBackground()
            .anyButton(.pressable()) {
                
            }
        
        Text("PlainButton")
            .callToActionButton()
            .tappableBackground()
            .anyButton {
                
            }

    }
    .padding()
}
