//
//  FirebaseUserService.swift
//  AIChats
//
//  Created by sinduke on 1/1/26.
//

import FirebaseFirestore
import SwiftfulFirestore

struct FirebaseUserService: RemoteUserServiceProtocol {
    var collection: CollectionReference {
        Firestore.firestore().collection("users")
    }
    
    func save(_ user: UserModel) async throws {
//        使用StringIdentifiableCollectionReference可以简化代码
//        try collection.document(user.userID).setData(from: user, merge: true)
        try await collection.setDocument(document: user)
    }
    
    func streamUser(userID: String) -> AsyncThrowingStream<UserModel, Error> {
        collection.streamDocument(id: userID)
    }
    
    func markOnboardingCompleted(userID: String, profileColorHex: String) async throws {
        try await collection.document(userID).updateData([
            UserModel.CodingKeys.didCompleteOnboarding.rawValue: true,
            UserModel.CodingKeys.profileColorHex.rawValue: profileColorHex
        ])
    }
    
    func deleteUser(userID: String) async throws {
//        try await collection.document(userID).delete()
        try await collection.deleteDocument(id: userID)
    }
}
