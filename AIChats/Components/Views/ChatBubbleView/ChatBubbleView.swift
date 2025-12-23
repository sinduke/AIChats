//
//  ChatBubbleView.swift
//  AIChats
//
//  Created by sinduke on 12/18/25.
//

import SwiftUI

struct ChatBubbleView: View {
    var text: String = "This is a sample chat bubble."
    var textColor: Color = .primary
    var backgroundColor: Color = Color(.systemGray6)
    var imageName: String?
    var showImage: Bool = true
    var onImagePressed: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .top) {
            
            if showImage {
                ZStack {
                    if let imageName {
                        ImageLoadView(urlString: imageName)
                            .anyButton {
                                onImagePressed?()
                            }
                    } else {
                        Rectangle()
                            .fill(.secondary.opacity(0.5))
                    }
                }
                .frame(width: 45, height: 45)
                .clipShape(.circle)
                .offset(y: 10)
            }
            
            Text(text)
                .font(.body)
                .foregroundStyle(textColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(backgroundColor)
                .clipShape(.rect(cornerRadius: 6, style: .continuous))
        }
        .padding(.bottom, showImage ? 10 : 0)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            ChatBubbleView()
            ChatBubbleView(text: "Hello! How can I assist you today? Hello! How can I assist you today? Hello! How can I assist you today? Hello! How can I assist you today?")
            ChatBubbleView()
            
            ChatBubbleView(
                textColor: .white,
                backgroundColor: .accent,
                imageName: nil,
                showImage: false
            )
            ChatBubbleView(
                text: "Hello! How can I assist you today? Hello! How can I assist you today? Hello! How can I assist you today? Hello! How can I assist you today?",
                textColor: .white,
                backgroundColor: .accent,
                imageName: nil,
                showImage: false
            )
        }
        .padding(8)
    }
}
