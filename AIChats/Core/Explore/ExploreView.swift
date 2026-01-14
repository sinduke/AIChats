//
//  ExploreView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct ExploreView: View {
    
    @Environment(AvatarManager.self) private var avatarManager: AvatarManager
    
    @State private var featuredAvatars: [AvatarModel] = []
    @State private var popularAvatars: [AvatarModel] = []
    @State private var categories: [CharacterOption] = CharacterOption.allCases
    
    @State private var path: [NavigationPathOption] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                
                if featuredAvatars.isEmpty && popularAvatars.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .removeListRowFormatting()
                }
                
                if !featuredAvatars.isEmpty {
                    featuredSection
                }

                if !popularAvatars.isEmpty {
                    categoriesSection
                    popularSection
                }
            }
            .navigationTitle("Explore")
            .navigationDestinationForCoreModule(path: $path)
            .task {
                await loadFeatureAvatars()
            }
            .task {
                await loadPopularAvatars()
            }
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
    private func loadFeatureAvatars() async {
        guard featuredAvatars.isEmpty else { return }
        do {
            featuredAvatars = try await avatarManager.getFeaturedAvatars()
        } catch {
            print("Failed to load featured avatars: \(error)")
        }
    }
    
    private func loadPopularAvatars() async {
        guard popularAvatars.isEmpty else { return }
        do {
            popularAvatars = try await avatarManager.getPopularAvatars()
        } catch {
            print("Failed to load popular avatars: \(error)")
        }
    }
    
    private func onAvatarPressed(avatar: AvatarModel) {
        path.append(.chat(avatarID: avatar.avatarID))
    }
    
    private func onCategoryPressed(category: CharacterOption, imageName: String) {
        path.append(.category(category: category, imageName: imageName))
    }
}

#Preview {
    ExploreView()
        .environment(AvatarManager(remote: MockAvatarService()))
}
