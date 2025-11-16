//
//  ChatMessageModel.swift
//  AIChats
//
//  Created by sinduke on 11/11/25.
//

import SwiftUI

struct ChatMessageModel {
    let id: String
    let chatID: String
    let authorID: String?
    let content: String?
    let sendByIDs: [String]?
    let dateCreated: Date?
    
    init(
        id: String,
        chatID: String,
        authorID: String? = nil,
        content: String? = nil,
        sendByIDs: [String]? = nil,
        dateCreated: Date? = nil
    ) {
        self.id = id
        self.chatID = chatID
        self.authorID = authorID
        self.content = content
        self.sendByIDs = sendByIDs
        self.dateCreated = dateCreated
    }
    
    func hasBeenSentByCurrentUser(userID: String) -> Bool {
        guard let sendByIDs else { return false }
        return sendByIDs.contains(userID)
    }
    
    static var mock: Self {
        mocks.first!
    }
    
    static var mocks: [Self] {
        [
            ChatMessageModel(
                id: UUID().uuidString,
                chatID: "chat_001",
                authorID: "user_001",
                content: "Hey there! How are you doing today?",
                sendByIDs: ["user_001"],
                dateCreated: Date().addingTimeInterval(days: -2, hours: -3)
            ),
            ChatMessageModel(
                id: UUID().uuidString,
                chatID: "chat_001",
                authorID: "user_002",
                content: "I'm good! Just working on the new SwiftUI layout we discussed.",
                sendByIDs: ["user_002"],
                dateCreated: Date().addingTimeInterval(days: -2, hours: -2, minutes: -30)
            ),
            ChatMessageModel(
                id: UUID().uuidString,
                chatID: "chat_001",
                authorID: "user_001",
                content: "Nice! Did you manage to fix the animation bug?",
                sendByIDs: ["user_001"],
                dateCreated: Date().addingTimeInterval(days: -2, hours: -2)
            ),
            ChatMessageModel(
                id: UUID().uuidString,
                chatID: "chat_001",
                authorID: "user_002",
                content: "Yeah, turns out it was because of `.animation(.default)` applied twice.",
                sendByIDs: ["user_002"],
                dateCreated: Date().addingTimeInterval(days: -2, hours: -1, minutes: -45)
            ),
            ChatMessageModel(
                id: UUID().uuidString,
                chatID: "chat_001",
                authorID: "user_001",
                content: "😂 Classic SwiftUI moment. Let's refactor it with `withAnimation` instead.",
                sendByIDs: ["user_001"],
                dateCreated: Date().addingTimeInterval(days: -2, hours: -1)
            ),
            ChatMessageModel(
                id: UUID().uuidString,
                chatID: "chat_001",
                authorID: "user_002",
                content: "Agreed. I'll push the fix tonight.",
                sendByIDs: ["user_002"],
                dateCreated: Date().addingTimeInterval(days: -1, hours: -23, minutes: -30)
            )
        ]
    }
}
