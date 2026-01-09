//
//  AvatarManager.swift
//  AIChats
//
//  Created by sinduke on 1/8/26.
//

import SwiftUI

protocol AvatarServiceProtocol {
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws
}

struct MockAvatarService: AvatarServiceProtocol {
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
        
    }
}

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
}

@Observable
final class AvatarManager {
    private let service: AvatarServiceProtocol
    
    init(service: AvatarServiceProtocol) {
        self.service = service
    }
    
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
        try await service.createAvatar(avatar: avatar, image: image)
    }
    
}
