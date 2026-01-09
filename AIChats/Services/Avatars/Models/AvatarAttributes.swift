//
//  AvatarAttributes.swift
//  AIChats
//
//  Created by sinduke on 12/18/25.
//

import SwiftUI

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
        let prefix = characterOption.startWithVowel ? "An" : "A"
        return "\(prefix) \(characterOption) who is \(characterAction) at the \(characterLocation)."
    }
    
}

enum CharacterOption: String, CaseIterable, Hashable, Codable {
    case man, woman, cat, dog, alien
    
    static var `default`: Self {
        .man
    }
    
    var plural: String {
        switch self {
        case .man:
            "men"
        case .woman:
            "women"
        case .cat:
            "cats"
        case .dog:
            "dogs"
        case .alien:
            "aliens"
        }
    }
    
    var startWithVowel: Bool {
        switch self {
        case .alien:
            return true
        default:
            return false
        }
    }
}

enum CharacterAction: String, CaseIterable, Hashable, Codable {
    case eating, smiling, working, playing, drinking, shopping, relaxing, fighting
    
    static var `default`: Self {
        .relaxing
    }
}

enum CharacterLocation: String, CaseIterable, Hashable, Codable {
    case home, office, park, beach, space, city, market
    
    static var `default`: Self {
        .park
    }
}
