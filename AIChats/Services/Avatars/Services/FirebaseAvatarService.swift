//
//  FirebaseAvatarService.swift
//  AIChats
//
//  Created by sinduke on 1/14/26.
//

import FirebaseFirestore
import SwiftfulFirestore

struct FirebaseAvatarService: AvatarServiceProtocol {
    private let imageUploader: ImageUploadServiceProtocol
    
    var collection: CollectionReference {
        Firestore.firestore().collection("avatars")
    }
    
    init(imageUploader: ImageUploadServiceProtocol) {
        self.imageUploader = imageUploader
    }
    
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
        // uploadImage
        let path = "avatars/\(avatar.avatarID)"
        let url =  try await imageUploader.uploadImage(image: image, path: path)
        // update avatar
        let newAvatar = avatar.copy(profileImageName: url.absoluteString)
        // uploadAvatar
        try collection.document(avatar.avatarID).setData(from: newAvatar)
    }

    func getFeaturedAvatars() async throws -> [AvatarModel] {
        try await collection
            .limit(to: 50)
            .getAllDocuments()
            .shuffled()
            .first(upTo: 5) ?? []
    }

    func getPopularAvatars() async throws -> [AvatarModel] {
        try await collection
            .limit(to: 200)
            .getAllDocuments()
    }

    func getAvatarsForCategory(category: CharacterOption) async throws -> [AvatarModel] {
        try await collection
            .whereField(AvatarModel.CodingKeys.characterOption.rawValue, isEqualTo: category.rawValue)
            .limit(to: 200)
            .getAllDocuments()
    }

    func getAvatarsForAuthor(authorID: String) async throws -> [AvatarModel] {
        try await collection
            .whereField(AvatarModel.CodingKeys.authID.rawValue, isEqualTo: authorID)
            .limit(to: 100)
            .getAllDocuments()
    }
}
