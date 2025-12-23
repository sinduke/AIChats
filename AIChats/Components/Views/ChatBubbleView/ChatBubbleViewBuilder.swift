//
//  ChatBubbleViewBuilder.swift
//  AIChats
//
//  Created by sinduke on 12/18/25.
//

import SwiftUI

struct ChatBubbleViewBuilder: View {
    var chatMessage: ChatMessageModel = .mock
    var isCurrentUser: Bool = false
    var imageName: String?
    var onImagePressed: (() -> Void)?
    
    var body: some View {
        ChatBubbleView(
            text: chatMessage.content ?? "",
            textColor: isCurrentUser ? .white : .primary,
            backgroundColor: isCurrentUser ? .accent : Color(.systemGray6),
            imageName: imageName,
            showImage: !isCurrentUser,
            onImagePressed: onImagePressed
        )
        .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading)
        .padding(.leading, isCurrentUser ? 50 : 0)
        .padding(.trailing, isCurrentUser ? 0 : 50)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 24) {
            ChatBubbleViewBuilder()
            ChatBubbleViewBuilder(isCurrentUser: true)
            ChatBubbleViewBuilder()
            ChatBubbleViewBuilder(isCurrentUser: true)
            ChatBubbleViewBuilder(
                chatMessage: ChatMessageModel(
                    id: UUID().uuidString,
                    chatID: UUID().uuidString,
                    authorID: UUID().uuidString,
                    content: "Hello, how can I assist you today?",
                    sendByIDs: nil,
                    dateCreated: .now
                ),
                isCurrentUser: false,
            )
            ChatBubbleViewBuilder(
                chatMessage: ChatMessageModel(
                    id: UUID().uuidString,
                    chatID: UUID().uuidString,
                    authorID: UUID().uuidString,
                    content: "Hello, how can I assist you today?",
                    sendByIDs: nil,
                    dateCreated: .now
                ),
                isCurrentUser: true,
            )
        }
        .padding()
    }
}
