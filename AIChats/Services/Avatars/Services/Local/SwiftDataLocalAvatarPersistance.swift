//
//  SwiftDataLocalAvatarPersistance.swift
//  AIChats
//
//  Created by sinduke on 1/14/26.
//

import SwiftUI
import SwiftData

// Note: 在轻量化的情况下使用struct 但是需要注意SwiftData的ModelContainer要求是引用类型 最好使用class
struct SwiftDataLocalAvatarPersistance: LocalAvatarPersistanceProtocol {
    
    private let container: ModelContainer
    private var mainContext: ModelContext {
        container.mainContext
    }

    init() {
        do {
            self.container = try ModelContainer(for: AvatarEntity.self)
        } catch {
            preconditionFailure("SwiftData container init failed: \(error)")
        }
    }

    func addRecentAvatar(avatar: AvatarModel) throws {
        let entity = AvatarEntity(from: avatar)
        mainContext.insert(entity)
        try mainContext.save()
    }

    func getRecentAvatars() throws -> [AvatarModel] {
        let fetchRequest = FetchDescriptor<AvatarEntity>(sortBy: [SortDescriptor(\.dateAdded, order: .reverse)])
        let entities = try mainContext.fetch(fetchRequest)
        return entities.map { $0.toModel() }
    }

}
