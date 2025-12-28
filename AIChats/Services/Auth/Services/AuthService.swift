//
//  AuthService.swift
//  AIChats
//
//  Created by sinduke on 12/29/25.
//

import SwiftUI

// protocol AuthService: Sendable {
protocol AuthService: Sendable {
    func getAuthenticatedUser() -> UserAuthInfo?
    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool)
    func signInWithApple() async throws -> (user: UserAuthInfo, isNewUser: Bool)
    func signOut() throws
    func deleteAccount() async throws
}

extension EnvironmentValues {
    @Entry var authService: AuthService = MockAuthService()
}
