//
//  AvatarManager.swift
//  AIChats
//
//  Created by sinduke on 1/8/26.
//

import SwiftUI

@Observable
final class AvatarManager {
    private let service: AvatarServiceProtocol
    
    init(service: AvatarServiceProtocol) {
        self.service = service
    }
    
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
        try await service.createAvatar(avatar: avatar, image: image)
    }

    func getFeaturedAvatars() async throws -> [AvatarModel] {
        try await service.getFeaturedAvatars()
    }
    
    func getPopularAvatars() async throws -> [AvatarModel] {
        try await service.getPopularAvatars()
    }

    func getAvatarsForCategory(category: CharacterOption) async throws -> [AvatarModel] {
        try await service.getAvatarsForCategory(category: category)
    }

    func getAvatarsForAuthor(authorID: String) async throws -> [AvatarModel] {
        try await service.getAvatarsForAuthor(authorID: authorID)
    }

}
