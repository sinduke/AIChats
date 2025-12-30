//
//  UserManager.swift
//  AIChats
//
//  Created by sinduke on 12/30/25.
//

import SwiftUI

// 是否需要显式遵循Sendable
protocol UserServiceProtocol {
    func save(_ user: UserModel) async throws
}

import FirebaseFirestore
struct FirebaseUserService: UserServiceProtocol {
    var collection: CollectionReference {
        Firestore.firestore().collection("users")
    }
    
    func save(_ user: UserModel) async throws {
        try collection.document(user.userID).setData(from: user, merge: true)
    }
}

// 用于登录后的储存
// @MainActor
@Observable
class UserManager {
    private let service: UserServiceProtocol
    private(set) var currentUser: UserModel?
    
    init(service: UserServiceProtocol) {
        self.service = service
        self.currentUser = nil
    }
    
    func logIn(user: UserAuthInfo, isNewUser: Bool) async throws {
        let creationVersion = isNewUser ? Utilities.appVersion : nil
        let user = UserModel(auth: user, creationVersion: creationVersion)
        // iOS26 如果UserServiceProtocol不添加Sendable这里会报错。但是现在不会 回头需要查明原因
        try await service.save(user)
    }
}
