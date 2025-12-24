//
//  NavigationPathOption.swift
//  AIChats
//
//  Created by sinduke on 12/24/25.
//

import SwiftUI

enum NavigationPathOption: Hashable {
    case chat(avatarID: String)
    case category(category: CharacterOption, imageName: String)
}

extension View {
    func navigationDestinationForCoreModule(path: Binding<[NavigationPathOption]>) -> some View {
        self
            .navigationDestination(for: NavigationPathOption.self) { newValue in
                switch newValue {
                case .chat(avatarID: let avatarID):
                    ChatView(avatarID: avatarID)
                case .category(category: let category, let imageName):
                    CategoryListView(path: path, category: category, imageName: imageName)
                }
            }
    }
}
