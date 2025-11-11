//
//  ChatsView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct ChatsView: View {
    @State private var chats: [ChatModel] = ChatModel.mocks
    var body: some View {
        NavigationStack {
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
                        // Handle chat selection
                    })
                    .removeListRowFormatting()
            }
            .navigationTitle("Chats")
        }
    }
}

#Preview {
    ChatsView()
}
