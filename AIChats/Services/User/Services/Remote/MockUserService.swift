//
//  MockUserService.swift
//  AIChats
//
//  Created by sinduke on 1/1/26.
//

import SwiftUI

struct MockUserService: RemoteUserServiceProtocol {
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
