//
//  UserAuthInfo.swift
//  AIChats
//
//  Created by sinduke on 12/26/25.
//

import SwiftUI

// 使用本地模型来解耦 Firebase 依赖
struct UserAuthInfo {
    let uid: String
    let email: String?
    let isAnonymous: Bool
    let creationDate: Date?
    let lastSignInDate: Date?
    
    init(
        uid: String,
        email: String? = nil,
        isAnonymous: Bool = false,
        creationDate: Date? = nil,
        lastSignInDate: Date? = nil
    ) {
        self.uid = uid
        self.email = email
        self.isAnonymous = isAnonymous
        self.creationDate = creationDate
        self.lastSignInDate = lastSignInDate
    }
    
    // 从 Firebase User 初始化
    static func mock(isAnonymous: Bool = false) -> Self {
        .init(
            uid: "mock_user_001",
            email: "sinduke@outlook.com",
            isAnonymous: isAnonymous,
            creationDate: .now,
            lastSignInDate: .now
        )
    }
}
