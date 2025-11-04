//
//  AvatarModel.swift
//  AIChats
//
//  Created by sinduke on 10/31/25.
//

import SwiftUI

struct AvatarModel: Hashable {
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
    
    static var mock: AvatarModel {
        mocks.first!
    }
    
    static var mocks: [AvatarModel] {
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

struct AvatarDescriptionBuilder {
    let characterOption: CharacterOption
    let characterAction: CharacterAction
    let characterLocation: CharacterLocation
    
    init(characterOption: CharacterOption, characterAction: CharacterAction, characterLocation: CharacterLocation) {
        self.characterOption = characterOption
        self.characterAction = characterAction
        self.characterLocation = characterLocation
    }
    
    init(avatar: AvatarModel) {
        self.characterOption = avatar.characterOption ?? .default
        self.characterAction = avatar.characterAction ?? .default
        self.characterLocation = avatar.characterLocation ?? .default
    }
    
    var characterDescription: String {
        "A \(characterOption) who is \(characterAction) at the \(characterLocation)."
    }
    
}

enum CharacterOption {
    case man, woman, cat, dog, alien
    
    static var `default`: Self {
        .man
    }
}

enum CharacterAction {
    case eating, smiling, working, playing, drinking, shopping, relaxing, fighting
    
    static var `default`: Self {
        .relaxing
    }
}

enum CharacterLocation {
    case home, office, park, beach, space, city, market
    
    static var `default`: Self {
        .park
    }
}
