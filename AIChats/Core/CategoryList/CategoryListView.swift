//
//  CategoryListView.swift
//  AIChats
//
//  Created by sinduke on 12/23/25.
//

import SwiftUI

struct CategoryListView: View {
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
            }
            .removeListRowFormatting()
        }
        .listStyle(.plain)
        .ignoresSafeArea()
    }
}

#Preview {
    CategoryListView()
}
