//
//  RemoteUserServiceProtocol.swift
//  AIChats
//
//  Created by sinduke on 1/1/26.
//

import SwiftUI

// 是否需要显式遵循Sendable
protocol RemoteUserServiceProtocol {
    func save(_ user: UserModel) async throws
    func streamUser(userID: String) -> AsyncThrowingStream<UserModel, Error>
    func markOnboardingCompleted(userID: String, profileColorHex: String) async throws
    func deleteUser(userID: String) async throws
}
