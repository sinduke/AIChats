//
//  FileManagerUserPersistentService.swift
//  AIChats
//
//  Created by sinduke on 1/1/26.
//

import SwiftUI

struct FileManagerUserPersistentService: LocalUserServiceProtocol {
    private let userDocumentKey: String = "current_user"
    
    func getCurrentUser() -> UserModel? {
        try? FileManager.getFromDocument(UserModel.self, from: userDocumentKey)
    }
    
    func saveUser(user: UserModel?) throws {
        try FileManager.saveToDocument(fileName: userDocumentKey, value: user)
    }
}
