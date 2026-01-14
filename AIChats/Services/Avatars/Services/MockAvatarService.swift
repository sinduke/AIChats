//
//  MockAvatarService.swift
//  AIChats
//
//  Created by sinduke on 1/14/26.
//

import SwiftUI

struct MockAvatarService: AvatarServiceProtocol {
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
        
    }

    func getFeaturedAvatars() async throws -> [AvatarModel] {
        try await Task.sleep(for: .seconds(2))
        return AvatarModel.mocks.shuffled()
    }

    func getPopularAvatars() async throws -> [AvatarModel] {
        try await Task.sleep(for: .seconds(3))
        return AvatarModel.mocks.shuffled()
    }

    func getAvatarsForCategory(category: CharacterOption) async throws -> [AvatarModel] {
        try await Task.sleep(for: .seconds(1))
        return AvatarModel.mocks.shuffled()
    }

    func getAvatarsForAuthor(authorID: String) async throws -> [AvatarModel] {
        try await Task.sleep(for: .seconds(1))
        return AvatarModel.mocks.shuffled()
    }
}
