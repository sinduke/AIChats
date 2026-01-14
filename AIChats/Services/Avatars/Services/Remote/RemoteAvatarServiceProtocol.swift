//
//  AvatarServiceProtocol.swift
//  AIChats
//
//  Created by sinduke on 1/14/26.
//

import SwiftUI

protocol RemoteAvatarServiceProtocol {
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws
    func getFeaturedAvatars() async throws -> [AvatarModel]
    func getPopularAvatars() async throws -> [AvatarModel]
    func getAvatarsForCategory(category: CharacterOption) async throws -> [AvatarModel]
    func getAvatarsForAuthor(authorID: String) async throws -> [AvatarModel]
    func getAvatarByID(avatarID: String) async throws -> AvatarModel
}
