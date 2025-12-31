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
    func streamUser(userID: String) -> AsyncThrowingStream<UserModel, Error>
    func markOnboardingCompleted(userID: String, profileColorHex: String) async throws
    func deleteUser(userID: String) async throws
}

struct MockUserService: UserServiceProtocol {
    let currentUser: UserModel?
    
    init(currentUser: UserModel? = nil) {
        self.currentUser = currentUser
    }
    
    func save(_ user: UserModel) async throws {
        
    }
    
    func streamUser(userID: String) -> AsyncThrowingStream<UserModel, any Error> {
        AsyncThrowingStream { continuation in
            if let user = currentUser {
                continuation.yield(user)
            }
        }
    }
    
    func markOnboardingCompleted(userID: String, profileColorHex: String) async throws {
        
    }
    
    func deleteUser(userID: String) async throws {
        
    }
}

import FirebaseFirestore
import SwiftfulFirestore

struct FirebaseUserService: UserServiceProtocol {
    var collection: CollectionReference {
        Firestore.firestore().collection("users")
    }
    
    func save(_ user: UserModel) async throws {
//        使用StringIdentifiableCollectionReference可以简化代码
//        try collection.document(user.userID).setData(from: user, merge: true)
        try await collection.setDocument(document: user)
    }
    
    func streamUser(userID: String) -> AsyncThrowingStream<UserModel, Error> {
        collection.streamDocument(id: userID)
    }
    
    func markOnboardingCompleted(userID: String, profileColorHex: String) async throws {
        try await collection.document(userID).updateData([
            UserModel.CodingKeys.didCompleteOnboarding.rawValue: true,
            UserModel.CodingKeys.profileColorHex.rawValue: profileColorHex
        ])
    }
    
    func deleteUser(userID: String) async throws {
//        try await collection.document(userID).delete()
        try await collection.deleteDocument(id: userID)
    }
}

// 用于登录后的储存
/**@MainActor*/
@Observable
class UserManager {
    private let service: UserServiceProtocol
    private(set) var currentUser: UserModel?
    private var userListenerTask: Task<Void, Never>?
    
    init(service: UserServiceProtocol) {
        self.service = service
        self.currentUser = nil
    }
    
    func logIn(user: UserAuthInfo, isNewUser: Bool) async throws {
        let creationVersion = isNewUser ? Utilities.appVersion : nil
        let user = UserModel(auth: user, creationVersion: creationVersion)
        // iOS26 如果UserServiceProtocol不添加Sendable这里会报错。但是现在不会 回头需要查明原因
        try await service.save(user)
        addCurrentUserListener(userID: user.userID)
    }
    
    private func addCurrentUserListener(userID: String) {
        stopListening()
        
        userListenerTask = Task {
            do {
                for try await value in service.streamUser(userID: userID) {
                    self.currentUser = value
                    print("Successfully got user of ID: \(value.userID)")
                }
            } catch {
                print("Error streaming user: \(error)")
            }
        }
    }
    
    func markOnboardingComoleteForCurrentUser(profileColorHex: String) async throws {
        let uid = try currentUserID()
        try await service.markOnboardingCompleted(userID: uid, profileColorHex: profileColorHex)
    }
    
    func stopListening() {
        userListenerTask?.cancel()
        userListenerTask = nil
    }
    
    func signOut() throws {
        self.currentUser = nil
        stopListening()
    }
    
    func deleteCurrentUser() async throws {
        let uid = try currentUserID()
        try await service.deleteUser(userID: uid)
        try signOut()
    }
    
    private func currentUserID() throws -> String {
        guard let uid = currentUser?.userID else {
            throw UserManagerError.noCurrentUser
        }
        return uid
    }
    
    enum UserManagerError: LocalizedError {
        case noCurrentUser
    }

}
