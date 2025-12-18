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
    @State private var textFieldText: String = ""
    @State private var showChatSettings: Bool = false
    @State private var scrollPosition: String?
    var body: some View {
        VStack(spacing: 0) {
            scrollSection
            textFieldSection
        }
        .navigationTitle(avatar?.name ?? "Chat")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "ellipsis")
                    .padding(8)
                    .anyButton {
                        onChatSettingsButtonTapped()
                    }
                    .confirmationDialog("", isPresented: $showChatSettings) {
                        Button("Report user/chat", role: .destructive) {
                            print("Report tapped")
                        }
                        Button("Delete chat", role: .destructive) {
                            print("Delete tapped")
                        }
                    } message: {
                        Text("What do you want to do?")
                    }
            }
        }
    }
    
    // MARK: -- Views --
    private var textFieldSection: some View {
        TextField("Say something...", text: $textFieldText)
//            .keyboardType(.alphabet)
//            .autocorrectionDisabled()
            .padding(12)
            .padding(.trailing, 40)
            .overlay(alignment: .trailing, content: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title)
                    .padding(.trailing, 4)
                    .foregroundStyle(.accent)
                    .anyButton {
                        onSendButtonTapped()
                    }
            })
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 100, style: .continuous)
                        .fill(Color(.systemBackground))
                    RoundedRectangle(cornerRadius: 100, style: .continuous)
                        .stroke(.gray.opacity(0.3), lineWidth: 1)
                }
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(.secondarySystemBackground))
    }
    
    private var scrollSection: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(chatMessages) { message in
                    let isCurrentUser = message.authorID == currentUser?.userID
                    ChatBubbleViewBuilder(
                        chatMessage: message,
                        isCurrentUser: isCurrentUser,
                        imageName: avatar?.profileImageName
                    )
                    .id(message.id)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .rotationEffect(.degrees(180))
        }
        .rotationEffect(.degrees(180))
        .scrollPosition(id: $scrollPosition, anchor: .center)
        .animation(.default, value: chatMessages.count)
        .animation(.default, value: scrollPosition)
    }
    // MARK: -- Functions --
    private func onSendButtonTapped() {
        guard let currentUser else { return }
        let content = textFieldText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !content.isEmpty else { return }
        let newMessage = ChatMessageModel(
            id: UUID().uuidString,
            chatID: UUID().uuidString,
            authorID: currentUser.userID,
            content: content,
            sendByIDs: nil,
            dateCreated: .now
        )
        chatMessages.append(newMessage)
        scrollPosition = newMessage.id
        textFieldText = ""
    }
    
    private func onChatSettingsButtonTapped() {
        showChatSettings = true
    }
}

#Preview {
    NavigationStack {
        ChatView()
    }
}
