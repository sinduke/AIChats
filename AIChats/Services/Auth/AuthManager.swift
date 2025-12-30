//
//  AuthManager.swift
//  AIChats
//
//  Created by sinduke on 12/29/25.
//

import SwiftUI

// @MainActor
@Observable
class AuthManager {
    private let service: AuthService
    private(set) var auth: UserAuthInfo?
    private var listener: (any NSObjectProtocol)?
    
    init(service: AuthService) {
        self.service = service
        self.auth = service.getAuthenticatedUser()
        self.addAuthListener()
    }
    
    func getAuthID() throws -> String {
        guard let uid = auth?.uid else {
            throw AuthError.notSignedIn
        }
        return uid
    }
    
    private func addAuthListener() {
        Task {
            for await event in service.addAuthenticatedUserListener(onListenerAttached: { listener in
                self.listener = listener
            }) {
                self.auth = event
                print("Auth listener triggered: \(event?.uid ?? "no uid")" )
            }
        }
    }
    
    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        try await service.signInAnonymously()
    }
    
    func signInWithApple() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        try await service.signInWithApple()
    }
    
    func signOut() throws {
        try service.signOut()
        auth = nil
    }
    
    func deleteAccount() async throws {
        try await service.deleteAccount()
        auth = nil
    }
    
    // MARK: -- Enums --
    enum AuthError: LocalizedError {
        case notSignedIn
    }
}
