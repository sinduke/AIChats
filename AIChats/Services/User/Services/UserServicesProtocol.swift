//
//  UserServicesProtocol.swift
//  AIChats
//
//  Created by sinduke on 1/1/26.
//

import SwiftUI

protocol UserServicesProtocol {
    var remote: RemoteUserServiceProtocol { get }
    var local: LocalUserServiceProtocol { get }
}

struct MockUserServiceContainer: UserServicesProtocol {
    let remote: RemoteUserServiceProtocol
    let local: LocalUserServiceProtocol
    
    init(user: UserModel? = nil) {
        self.remote = MockUserService(currentUser: user)
        self.local = MockUserPersistentService(currentUser: user)
    }
}

struct ProductUserServiceContainer: UserServicesProtocol {
    let remote: RemoteUserServiceProtocol = FirebaseUserService()
    let local: LocalUserServiceProtocol = FileManagerUserPersistentService()
}
