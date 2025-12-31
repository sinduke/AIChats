//
//  MockUserPersistentService.swift
//  AIChats
//
//  Created by sinduke on 1/1/26.
//

import SwiftUI

struct MockUserPersistentService: LocalUserServiceProtocol {
    let currentUser: UserModel?
    
    init(currentUser: UserModel? = nil) {
        self.currentUser = currentUser
    }
    
    func getCurrentUser() -> UserModel? {
        currentUser
    }
    
    func saveUser(user: UserModel?) throws {
        
    }
}
