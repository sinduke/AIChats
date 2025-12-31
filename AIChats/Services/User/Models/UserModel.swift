//
//  UserModel.swift
//  AIChats
//
//  Created by sinduke on 11/12/25.
//

import SwiftUI
import IdentifiableByString

struct UserModel: Codable, StringIdentifiable {
    var id: String {
        userID
    }
    let userID: String
    let email: String?
    let isAnonymous: Bool?
    let creationVersion: String?
    let creationDate: Date?
    let lastSignInDate: Date?
    let didCompleteOnboarding: Bool?
    let profileColorHex: String?
    
    init(
        userID: String,
        email: String? = nil,
        isAnonymous: Bool? = nil,
        creationDate: Date? = nil,
        creationVersion: String? = nil,
        lastSignInDate: Date? = nil,
        didCompleteOnboarding: Bool? = nil,
        profileColorHex: String? = nil
    ) {
        self.userID = userID
        self.email = email
        self.isAnonymous = isAnonymous
        self.creationDate = creationDate
        self.creationVersion = creationVersion
        self.lastSignInDate = lastSignInDate
        self.didCompleteOnboarding = didCompleteOnboarding
        self.profileColorHex = profileColorHex
    }
    
    init(auth: UserAuthInfo, creationVersion: String?) {
        self.init(
            userID: auth.uid,
            email: auth.email,
            isAnonymous: auth.isAnonymous,
            creationDate: auth.creationDate,
            creationVersion: creationVersion,
            lastSignInDate: auth.lastSignInDate
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case isAnonymous = "is_anonymous"
        case creationDate = "creation_date"
        case creationVersion = "creation_version"
        case lastSignInDate = "last_sign_in_date"
        case didCompleteOnboarding = "did_complete_onboarding"
        case profileColorHex = "profile_color_hex"
    }
    
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
                creationDate: Date().addingTimeInterval(days: -7, hours: -2),
                didCompleteOnboarding: true,
                profileColorHex: "#4ECDC4" // 青绿
            ),
            UserModel(
                userID: "user_002",
                creationDate: Date().addingTimeInterval(days: -3, hours: -6, minutes: -20),
                didCompleteOnboarding: false,
                profileColorHex: "#FF6B6B" // 热情红橙
            ),
            UserModel(
                userID: "user_003",
                creationDate: Date().addingTimeInterval(days: -1, hours: -1),
                didCompleteOnboarding: true,
                profileColorHex: "#FFD93D" // 明亮黄
            ),
            UserModel(
                userID: "user_004",
                creationDate: Date().addingTimeInterval(hours: -8),
                didCompleteOnboarding: false,
                profileColorHex: "#1A535C" // 深青蓝
            )
        ]
    }
    
}
