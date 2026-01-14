//
//  LocalAvatarPersistanceProtocol.swift
//  AIChats
//
//  Created by sinduke on 1/14/26.
//

import SwiftUI

protocol LocalAvatarPersistanceProtocol {
   func addRecentAvatar(avatar: AvatarModel) throws
   func getRecentAvatars() throws -> [AvatarModel]
}
