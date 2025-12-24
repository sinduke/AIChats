//
//  CategoryListView.swift
//  AIChats
//
//  Created by sinduke on 12/23/25.
//

import SwiftUI

struct CategoryListView: View {
    @Binding var path: [NavigationPathOption]
    var category: CharacterOption = .default
    var imageName: String = Constants.randomImageURL
    var avatars: [AvatarModel] = AvatarModel.mocks
    
    var body: some View {
        List {
            CategoryCellView(
                title: category.plural.capitalized,
                imageName: imageName,
                font: .largeTitle,
                cornerRadius: 0
            )
            .removeListRowFormatting()
            ForEach(avatars, id: \.self) { avatar in
                CustomListCellView(
                    imageName: avatar.profileImageName,
                    title: avatar.name,
                    subtitle: avatar.characterDescription
                )
                .anyButton {
                    onAvatarTapped(avatar: avatar)
                }
            }
            .removeListRowFormatting()
        }
        .listStyle(.plain)
        .ignoresSafeArea(edges: [.top, .leading, .trailing])
    }
    
    // MARK: -- Funcations --
    private func onAvatarTapped(avatar: AvatarModel) {
        path.append(.chat(avatarID: avatar.avatarID))
    }
}

#Preview {
    CategoryListView(path: .constant([]))
}
