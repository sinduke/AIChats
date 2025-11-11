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
                /*@START_MENU_TOKEN@*/Text(chat.id)/*@END_MENU_TOKEN@*/
            }
            .navigationTitle("Chats")
        }
    }
}

#Preview {
    ChatsView()
}
