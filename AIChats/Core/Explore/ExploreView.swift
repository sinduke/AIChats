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
    
    var body: some View {
        NavigationStack {
            List {
                featuredSection
                categoriesSection
                popularSection
            }
            .navigationTitle("Explore")
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
                    // Handle avatar selection
                }
            }
        } header: {
            Text("featured".capitalized)
        }
        .removeListRowFormatting()
    }
    
    private var categoriesSection: some View {
        Section {
            ZStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        ForEach(categories, id: \.self) { category in
                            CategoryCellView(
                                title: category.rawValue.capitalized,
                                imageName: Constants.randomImageURL
                            )
                            .anyButton {
                                // Handle category selection
                            }
                        }
                    }
                }
                .frame(height: 140)
                .scrollIndicators(.hidden)
                .scrollTargetLayout()
                .scrollTargetBehavior(.viewAligned)
            }
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
                    // Handle avatar selection
                }
            }
        } header: {
            Text("popular".capitalized)
        }
        .removeListRowFormatting()
    }
}

#Preview {
    ExploreView()
}
