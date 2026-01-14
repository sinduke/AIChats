//
//  AvatarManager.swift
//  AIChats
//
//  Created by sinduke on 1/8/26.
//

import SwiftUI

@Observable
final class AvatarManager {
    private let remote: RemoteAvatarServiceProtocol
    private let local: LocalAvatarPersistanceProtocol
    
    init(remote: RemoteAvatarServiceProtocol, local: LocalAvatarPersistanceProtocol = MockLocalAvatarPersistance()) {
        self.remote = remote
        self.local = local
    }
    
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
        try await remote.createAvatar(avatar: avatar, image: image)
    }
    
    func getFeaturedAvatars() async throws -> [AvatarModel] {
        try await remote.getFeaturedAvatars()
    }
    
    func getPopularAvatars() async throws -> [AvatarModel] {
        try await remote.getPopularAvatars()
    }

    func getAvatarsForCategory(category: CharacterOption) async throws -> [AvatarModel] {
        try await remote.getAvatarsForCategory(category: category)
    }

    func getAvatarsForAuthor(authorID: String) async throws -> [AvatarModel] {
        try await remote.getAvatarsForAuthor(authorID: authorID)
    }

    func getAvatarByID(avatarID: String) async throws -> AvatarModel {
        try await remote.getAvatarByID(avatarID: avatarID)
    }

    func addRecentAvatar(avatar: AvatarModel) throws {
        try local.addRecentAvatar(avatar: avatar)
    }

    func getRecentAvatars() throws -> [AvatarModel] {
        try local.getRecentAvatars()
    }
}
