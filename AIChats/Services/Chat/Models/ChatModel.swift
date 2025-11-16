//
//  ChatModel.swift
//  AIChats
//
//  Created by sinduke on 11/11/25.
//

import SwiftUI

struct ChatModel: Identifiable {
    let id: String
    let userID: String
    let avatarID: String
    let dateCreated: Date?
    let dateModified: Date?
    
    static var mock: Self {
        mocks.first!
    }
    
    static var mocks: [Self] {
        [
            ChatModel(
                id: "mock_chat_001",
                userID: "user_001",
                avatarID: "avatar_01",
                dateCreated: Date().addingTimeInterval(days: -2),
                dateModified: Date().addingTimeInterval(days: -1)
            ),
            ChatModel(
                id: "mock_chat_002",
                userID: "user_002",
                avatarID: "avatar_02",
                dateCreated: Date().addingTimeInterval(days: -3, hours: -6),
                dateModified: Date().addingTimeInterval(hours: -10)
            ),
            ChatModel(
                id: "mock_chat_003",
                userID: "user_003",
                avatarID: "avatar_03",
                dateCreated: Date().addingTimeInterval(days: -5),
                dateModified: Date().addingTimeInterval(days: -4, hours: -3)
            ),
            ChatModel(
                id: "mock_chat_004",
                userID: "user_004",
                avatarID: "avatar_04",
                dateCreated: Date().addingTimeInterval(days: -10),
                dateModified: Date().addingTimeInterval(days: -2)
            ),
            ChatModel(
                id: "mock_chat_005",
                userID: "user_005",
                avatarID: "avatar_05",
                dateCreated: Date().addingTimeInterval(days: -20, hours: -5),
                dateModified: Date().addingTimeInterval(days: -1, hours: -12)
            ),
            ChatModel(
                id: "mock_chat_006",
                userID: "user_006",
                avatarID: "avatar_06",
                dateCreated: Date().addingTimeInterval(days: -15, hours: -8),
                dateModified: Date()
            )
        ]
    }
}
