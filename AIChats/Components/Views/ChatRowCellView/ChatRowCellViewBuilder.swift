//
//  ChatRowCellViewBuilder.swift
//  AIChats
//
//  Created by sinduke on 11/11/25.
//

import SwiftUI

struct ChatRowCellViewBuilder: View {
    var currentUserID: String?
    var chat: ChatModel = .mock
    var getAvatar: () async -> AvatarModel?
    var getLastChatMessage: () async -> ChatMessageModel?
    @State private var avatar: AvatarModel?
    @State private var lastChatMessage: ChatMessageModel?
    @State private var didLoadAvatar: Bool = false
    @State private var didLoadLastChatMessage: Bool = false
    
    private var isLoading: Bool {
//        (didLoadAvatar && didLoadLastChatMessage) ? false : true
        !(didLoadAvatar && didLoadLastChatMessage)
    }
    
    private var hasNewMessage: Bool {
        guard let lastChatMessage, let currentUserID else {
            return false
        }
        return lastChatMessage.hasBeenSentByCurrentUser(userID: currentUserID)
    }
    
    var body: some View {
        ChatRowCellView(
            imageName: avatar?.profileImageName,
            headline: isLoading ? "xxxx xxxx" : avatar?.name ?? "Unknown",
            subheadline: isLoading ? "xxxx xxxx xxxx xxxx" : lastChatMessage?.content ?? "No messages yet.",
            hasNewMessage: isLoading ? false : hasNewMessage,
        )
        .redacted(reason: isLoading ? .placeholder : [])
        .task {
            await avatar = getAvatar()
            didLoadAvatar = true
        }
        .task {
            await lastChatMessage = getLastChatMessage()
            didLoadLastChatMessage = true
        }
    }
    
}

#Preview {
    VStack {
        ChatRowCellViewBuilder(chat: .mock) {
            .mock
        } getLastChatMessage: {
            .mock
        }
        
        ChatRowCellViewBuilder(chat: .mock) {
            try? await Task.sleep(for: .seconds(3))
            return .mock
        } getLastChatMessage: {
            try? await Task.sleep(for: .seconds(3))
            return .mock
        }
        
        ChatRowCellViewBuilder(chat: .mock) {
            .mock
        } getLastChatMessage: {
            .mock
        }
        
        ChatRowCellViewBuilder(chat: .mock) {
            nil
        } getLastChatMessage: {
            nil
        }
        
        ChatRowCellViewBuilder(chat: .mock) {
            nil
        } getLastChatMessage: {
            .mock
        }
        
        ChatRowCellViewBuilder(chat: .mock) {
            .mock
        } getLastChatMessage: {
            nil
        }
    }
}
