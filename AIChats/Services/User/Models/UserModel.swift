//
//  UserModel.swift
//  AIChats
//
//  Created by sinduke on 11/12/25.
//

import SwiftUI

struct UserModel {
    let userID: String
    let dateCreated: Date?
    let didCompleteOnboarding: Bool?
    let profileColorHex: String?
    
    var profileColorCalculated: Color {
        guard let profileColorHex else {
            return .accent
        }
        return Color(hex: profileColorHex) ?? .accent
    }
    
    static var mock: Self {
        mocks.first!
    }
    
    static var mocks: [Self] {
        [
            UserModel(
                userID: "user_001",
                dateCreated: Date().addingTimeInterval(days: -7, hours: -2),
                didCompleteOnboarding: true,
                profileColorHex: "#4ECDC4" // 青绿
            ),
            UserModel(
                userID: "user_002",
                dateCreated: Date().addingTimeInterval(days: -3, hours: -6, minutes: -20),
                didCompleteOnboarding: false,
                profileColorHex: "#FF6B6B" // 热情红橙
            ),
            UserModel(
                userID: "user_003",
                dateCreated: Date().addingTimeInterval(days: -1, hours: -1),
                didCompleteOnboarding: true,
                profileColorHex: "#FFD93D" // 明亮黄
            ),
            UserModel(
                userID: "user_004",
                dateCreated: Date().addingTimeInterval(hours: -8),
                didCompleteOnboarding: false,
                profileColorHex: "#1A535C" // 深青蓝
            )
        ]
    }
    
}
