//
//  AvatarEntity.swift
//  AIChats
//
//  Created by sinduke on 1/14/26.
//

import SwiftUI
import SwiftData

@Model
class AvatarEntity {

    @Attribute(.unique) var avatarID: String
    var name: String?
    var characterOption: CharacterOption?
    var characterAction: CharacterAction?
    var characterLocation: CharacterLocation?
    var profileImageName: String?
    var authID: String?
    var dateCreated: Date?

    // 更新专用日期
    var dateAdded: Date

    init(from model: AvatarModel) {
        self.avatarID = model.avatarID
        self.name = model.name
        self.characterOption = model.characterOption
        self.characterAction = model.characterAction
        self.characterLocation = model.characterLocation
        self.profileImageName = model.profileImageName
        self.authID = model.authID
        self.dateCreated = model.dateCreated
        self.dateAdded = .now
    }
    
    @MainActor
    func toModel() -> AvatarModel {
        AvatarModel(
            avatarID: avatarID,
            name: name,
            characterOption: characterOption,
            characterAction: characterAction,
            characterLocation: characterLocation,
            profileImageName: profileImageName,
            authID: authID,
            dateCreated: dateCreated
        )
    }
}
