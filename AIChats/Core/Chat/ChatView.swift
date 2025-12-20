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
    @State private var scrollPosition: String?
    @State private var showChatSettings: AnyAppAlert?
    @State private var showAlert: AnyAppAlert?
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
                    .showCustomAlert(type: .confirmationDialog, $showChatSettings)
            }
        }
        .showCustomAlert($showAlert)
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
    // MARK: -- Enums
    enum TextValidError: LocalizedError {
        case notEnoughCharacters(min: Int)
        case containsProhibitedWord(word: String)
        
        var errorDescription: String? {
            switch self {
            case .notEnoughCharacters(let min):
                return "Please enter at least \(min) characters."
            case .containsProhibitedWord(let word):
                return "Your message contains prohibited language: \"\(word)\""
            }
        }
    }
    // MARK: -- Functions --
    private func checkIfTextisValid(_ text: String) throws {
        let minimumNumberOfCharacters: Int = 3
        let badWrods: [String] = ["shit", "damn", "bitch", "ass", "fuck"]
        let filter = ProfanityFilter(
            banned: badWrods,
            minChars: minimumNumberOfCharacters
        )
        
        try filter.validate(text) { failure -> TextValidError in
            // 把 ProfanityFilter 的“命中词/原因”映射成你 View 内部的 TextValidError
            switch failure {
            case .tooShort(let min):
                return .notEnoughCharacters(min: min)
            case .hit(let word):
                return .containsProhibitedWord(word: word)
            }
        }
    }
    
    private func onSendButtonTapped() {
        guard let currentUser else { return }
        let content = textFieldText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !content.isEmpty else { return }
        do {
            try checkIfTextisValid(content)
            
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
            
        } catch {
            showAlert = AnyAppAlert(error: error)
        }
    }
    
    private func onChatSettingsButtonTapped() {
        showChatSettings = AnyAppAlert(
            title: "",
            message: "What would you like to do?",
            buttons: {
                AnyView(
                    Group {
                        Button("Report User/Chat", role: .destructive) {
                            
                        }
                        Button("Delete Chat", role: .destructive) {
                            
                        }
                    }
                )
            }
        )
    }
}

#Preview {
    NavigationStack {
        ChatView()
    }
}
