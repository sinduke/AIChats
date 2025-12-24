//
//  ChatsView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct ChatsView: View {
    @State private var chats: [ChatModel] = ChatModel.mocks
    
    @State private var path: [NavigationPathOption] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            List(chats) { chat in
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
                    .removeListRowFormatting()
            }
            .navigationTitle("Chats")
            .navigationDestinationForCoreModule(path: $path)
        }
    }
    
    // MARK: -- Funcations --
    private func onChatPressed(chat: ChatModel) {
        path.append(.chat(avatarID: chat.avatarID))
    }
}

#Preview {
    ChatsView()
}
