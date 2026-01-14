//
//  AvatarModel.swift
//  AIChats
//
//  Created by sinduke on 10/31/25.
//

import SwiftUI
import IdentifiableByString

struct AvatarModel: Hashable, Identifiable, Codable, StringIdentifiable {
    var id: String { avatarID }
    let avatarID: String
    let name: String?
    let characterOption: CharacterOption?
    let characterAction: CharacterAction?
    let characterLocation: CharacterLocation?
    let profileImageName: String?
    let authID: String?
    let dateCreated: Date?
    
    init(
        avatarID: String,
        name: String? = nil,
        characterOption: CharacterOption? = nil,
        characterAction: CharacterAction? = nil,
        characterLocation: CharacterLocation? = nil,
        profileImageName: String? = nil,
        authID: String? = nil,
        dateCreated: Date? = nil
    ) {
        self.avatarID = avatarID
        self.name = name
        self.characterOption = characterOption
        self.characterAction = characterAction
        self.characterLocation = characterLocation
        self.profileImageName = profileImageName
        self.authID = authID
        self.dateCreated = dateCreated
    }
    
    var characterDescription: String {
        AvatarDescriptionBuilder(avatar: self).characterDescription
    }
    
    enum CodingKeys: String, CodingKey {
        case avatarID = "avatar_id"
        case name
        case characterOption = "character_option"
        case characterAction = "character_action"
        case characterLocation = "character_location"
        case profileImageName = "profile_image_name"
        case authID = "auth_id"
        case dateCreated = "date_created"
    }

    static var mock: Self {
        mocks.first!
    }
    
    static var mocks: [Self] {
        [
            AvatarModel(
                avatarID: "1",
                name: "Alice",
                characterOption: .woman,
                characterAction: .smiling,
                characterLocation: .park,
                profileImageName: Constants.randomImageURL
            ),
            AvatarModel(
                avatarID: "2",
                name: "Bob",
                characterOption: .man,
                characterAction: .working,
                characterLocation: .office,
                profileImageName: Constants.randomImageURL
            ),
            AvatarModel(
                avatarID: "3",
                name: "Coco",
                characterOption: .cat,
                characterAction: .playing,
                characterLocation: .home,
                profileImageName: Constants.randomImageURL
            ),
            AvatarModel(
                avatarID: "4",
                name: "Daisy",
                characterOption: .woman,
                characterAction: .shopping,
                characterLocation: .market,
                profileImageName: Constants.randomImageURL
            ),
            AvatarModel(
                avatarID: "5",
                name: "Echo",
                characterOption: .alien,
                characterAction: .drinking,
                characterLocation: .space,
                profileImageName: Constants.randomImageURL
            )
        ]
    }
}

extension AvatarModel {
    func copy(
        name: String? = nil,
        characterOption: CharacterOption? = nil,
        characterAction: CharacterAction? = nil,
        characterLocation: CharacterLocation? = nil,
        profileImageName: String? = nil,
        authID: String? = nil,
        dateCreated: Date? = nil
    ) -> AvatarModel {
        AvatarModel(
            avatarID: avatarID, // 通常 id 不给改
            name: name ?? self.name,
            characterOption: characterOption ?? self.characterOption,
            characterAction: characterAction ?? self.characterAction,
            characterLocation: characterLocation ?? self.characterLocation,
            profileImageName: profileImageName ?? self.profileImageName,
            authID: authID ?? self.authID,
            dateCreated: dateCreated ?? self.dateCreated
        )
    }
}
