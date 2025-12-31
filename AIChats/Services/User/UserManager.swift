//
//  UserManager.swift
//  AIChats
//
//  Created by sinduke on 12/30/25.
//

import SwiftUI

// 用于登录后的储存
/**@MainActor*/
@Observable
class UserManager {
    private let remote: RemoteUserServiceProtocol
    private let local: LocalUserServiceProtocol
    private(set) var currentUser: UserModel?
    private var userListenerTask: Task<Void, Never>?
    
    init(services: UserServicesProtocol) {
        self.remote = services.remote
        self.local = services.local
        self.currentUser = local.getCurrentUser()
        print("Loaded current user from local: \(String(describing: currentUser?.userID))")
        print("UserManager init:", ObjectIdentifier(self))
        Thread.callStackSymbols.prefix(10).forEach { print($0) }
        print("MAEK: TEST LOAD Times")
    }
    
    func logIn(user: UserAuthInfo, isNewUser: Bool) async throws {
        let creationVersion = isNewUser ? Utilities.appVersion : nil
        let user = UserModel(auth: user, creationVersion: creationVersion)
        // iOS26 如果UserServiceProtocol不添加Sendable这里会报错。但是现在不会 回头需要查明原因
        try await remote.save(user)
        addCurrentUserListener(userID: user.userID)
    }
    
    private func saveCurrentUserLocally() {
        Task {
            do {
                try local.saveUser(user: currentUser)
                print("Successfully saved user locally: \(String(describing: currentUser?.userID))")
            } catch {
                print("Error saving user locally: \(error)")
            }
        }
    }
    
    private func addCurrentUserListener(userID: String) {
        stopListening()
        
        userListenerTask = Task {
            do {
                for try await value in remote.streamUser(userID: userID) {
                    self.currentUser = value
                    saveCurrentUserLocally()
                    print("Successfully got user of ID: \(value.userID)")
                }
            } catch {
                print("Error streaming user: \(error)")
            }
        }
    }
    
    func markOnboardingComoleteForCurrentUser(profileColorHex: String) async throws {
        let uid = try currentUserID()
        try await remote.markOnboardingCompleted(userID: uid, profileColorHex: profileColorHex)
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
        try await remote.deleteUser(userID: uid)
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
