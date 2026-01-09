//
//  FirebaseImageUploadService.swift
//  AIChats
//
//  Created by sinduke on 1/9/26.
//

import SwiftUI
import FirebaseStorage

protocol ImageUploadServiceProtocol {
    func uploadImage(image: UIImage, path: String) async throws -> URL
}

struct FirebaseImageUploadService: ImageUploadServiceProtocol {
    
    func uploadImage(image: UIImage, path: String) async throws -> URL {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw URLError(.cannotDecodeContentData)
        }
        return try await FirebaseStorageActor.shared.uploadJPEG(data, toPath: path)
    }
}

actor FirebaseStorageActor {
    static let shared = FirebaseStorageActor()

    func uploadJPEG(_ data: Data, toPath path: String) async throws -> URL {
        let ref = Storage.storage().reference(withPath: "\(path).jpg")

        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"

        _ = try await ref.putDataAsync(data, metadata: meta)
        return try await ref.downloadURL()
    }
}
