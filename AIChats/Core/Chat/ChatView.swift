//
//  ChatView.swift
//  AIChats
//
//  Created by sinduke on 12/18/25.
//

import SwiftUI

struct ChatView: View {
    @State private var chatMessages: [ChatMessageModel] = ChatMessageModel.mocks
    @State private var avatar: AvatarModel? = .mock
    @State private var currentUser: UserModel? = .mock
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(chatMessages) { message in
                        let isCurrentUser = message.authorID == currentUser?.userID
                        ChatBubbleViewBuilder(
                            chatMessage: message,
                            isCurrentUser: isCurrentUser,
                            imageName: avatar?.profileImageName
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(8)
            }
            
            Rectangle()
                .frame(height: 50)
        }
        .navigationTitle(avatar?.name ?? "Chat")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ChatView()
    }
}
