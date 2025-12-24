//
//  ChatsView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct ChatsView: View {
    
    @State private var chats: [ChatModel] = ChatModel.mocks
    @State private var recentAvatar: [AvatarModel] = AvatarModel.mocks
    
    @State private var path: [NavigationPathOption] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                if !recentAvatar.isEmpty {
                    recentSection
                }
                
                chatsSection
            }
            .navigationTitle("Chats")
            .navigationDestinationForCoreModule(path: $path)
        }
    }
    
    // MARK: -- Views --
    private var recentSection: some View {
        Section {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(recentAvatar, id: \.self) { avatar in
                        if let imageName = avatar.profileImageName {
                            VStack {
                                ImageLoadView(urlString: imageName)
                                    .aspectRatio(1, contentMode: .fit)
                                    .clipShape(.circle)
                                
                                Text(avatar.name ?? "")
                            }
                            .frame(maxWidth: .infinity)
                            .anyButton {
                                onAvatarPressed(avatar: avatar)
                            }
                        }
                    }
                    .padding(.top, 12)
                }
            }
            .scrollIndicators(.hidden)
            .frame(height: 120)
        } header: {
            Text("Recent")
        }
        .removeListRowFormatting()
    }
    
    private var chatsSection: some View {
        Section {
            if chats.isEmpty {
                ZStack {
                    ContentUnavailableView(
                        "No chat yet.",
                        systemImage: "bubbles.and.sparkles",
                        description: Text("Your chats will appear here.")
                    )
                }
                .removeListRowFormatting()
                .padding()
            } else {
                ForEach(chats) { chat in
                    ChatRowCellViewBuilder(
                        currentUserID: nil, // FIXME: - Pass current user ID here
                        chat: chat) {
                            try? await Task.sleep(for: .seconds(2))
                            return .mocks.randomElement()!
                        } getLastChatMessage: {
                            try? await Task.sleep(for: .seconds(2))
                            return .mocks.randomElement()!
                        }
                        .anyButton(.highlight, action: {
                            onChatPressed(chat: chat)
                        })
                }
                .removeListRowFormatting()
            }
        } header: {
            Text("chats".uppercased())
        }
    }
    
    // MARK: -- Funcations --
    private func onChatPressed(chat: ChatModel) {
        path.append(.chat(avatarID: chat.avatarID))
    }
    
    private func onAvatarPressed(avatar: AvatarModel) {
        path.append(.chat(avatarID: avatar.avatarID))
    }
}

#Preview {
    ChatsView()
}
