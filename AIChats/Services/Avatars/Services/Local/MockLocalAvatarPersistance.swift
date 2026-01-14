//
//  MockLocalAvatarPersistance.swift
//  AIChats
//
//  Created by sinduke on 1/14/26.
//

import SwiftUI

struct MockLocalAvatarPersistance: LocalAvatarPersistanceProtocol {
    
    func addRecentAvatar(avatar: AvatarModel) throws {
        // Mock implementation does nothing
    }
    
    func getRecentAvatars() throws -> [AvatarModel] {
        AvatarModel.mocks.shuffled()
    }
}
