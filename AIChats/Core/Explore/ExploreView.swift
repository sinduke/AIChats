//
//  ExploreView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct ExploreView: View {
    
    @State private var featuredAvatars: [AvatarModel] = AvatarModel.mocks
    @State private var categories: [CharacterOption] = CharacterOption.allCases
    @State private var popularAvatars: [AvatarModel] = AvatarModel.mocks
    
    @State private var path: [NavigationPathOption] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                featuredSection
                categoriesSection
                popularSection
            }
            .navigationTitle("Explore")
            .navigationDestinationForCoreModule(path: $path)
        }
    }
    
    // MARK: -- Views
    private var featuredSection: some View {
        Section {
            CarouselView(items: featuredAvatars) { avatar in
                HeroCellView(
                    title: avatar.name,
                    subtitle: avatar.characterDescription,
                    image: avatar.profileImageName
                )
                .anyButton {
                    onAvatarPressed(avatar: avatar)
                }
            }
        } header: {
            Text("featured".capitalized)
        }
        .removeListRowFormatting()
    }
    
    private var categoriesSection: some View {
        Section {
            let imageMap: [CharacterOption: String] = popularAvatars.reduce(into: [:]) { dict, avatar in
                guard let option = avatar.characterOption else { return }
                dict[option] = dict[option] ?? avatar.profileImageName // 保留第一个
                // dict[option] = avatar.profileImageName              // 保留最后一个
            }
            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(categories, id: \.self) { category in
                        if let imageName = imageMap[category] {
                            CategoryCellView(
                                title: category.plural.capitalized,
                                imageName: imageName
                            )
                            .anyButton {
                                onCategoryPressed(category: category, imageName: imageName)
                            }
                        }
                    }
                }
            }
            .frame(height: 140)
            .scrollIndicators(.hidden)
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
        } header: {
            Text("categories".capitalized)
        }
        .removeListRowFormatting()
    }
    
    private var popularSection: some View {
        Section {
            ForEach(popularAvatars, id: \.self) { avatar in
                CustomListCellView(
                    imageName: avatar.profileImageName,
                    title: avatar.name,
                    subtitle: avatar.characterDescription
                )
                .anyButton(.highlight) {
                    onAvatarPressed(avatar: avatar)
                }
            }
        } header: {
            Text("popular".capitalized)
        }
        .removeListRowFormatting()
    }
    
    // MARK: -- Funcations --
    private func onAvatarPressed(avatar: AvatarModel) {
        path.append(.chat(avatarID: avatar.avatarID))
    }
    
    private func onCategoryPressed(category: CharacterOption, imageName: String) {
        path.append(.category(category: category, imageName: imageName))
    }
}

#Preview {
    ExploreView()
}
