//
//  CategoryListView.swift
//  AIChats
//
//  Created by sinduke on 12/23/25.
//

import SwiftUI

struct CategoryListView: View {

    @Environment(AvatarManager.self) private var avatarManager

    @Binding var path: [NavigationPathOption]
    var category: CharacterOption = .default
    var imageName: String = Constants.randomImageURL
    @State private var avatars: [AvatarModel] = []

    @State private var showAlert: AnyAppAlert?
    @State private var isLoading: Bool = true
    
    var body: some View {
        List {
            CategoryCellView(
                title: category.plural.capitalized,
                imageName: imageName,
                font: .largeTitle,
                cornerRadius: 0
            )
            .removeListRowFormatting()
            
            if avatars.isEmpty && isLoading {
                ProgressView()
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            } else {
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
        }
        .showCustomAlert($showAlert)
        .listStyle(.plain)
        .ignoresSafeArea(edges: [.top, .leading, .trailing])
        .task {
            await loadAvatarsForCategory()
        }
    }
    
    // MARK: -- Funcations --
    private func onAvatarTapped(avatar: AvatarModel) {
        path.append(.chat(avatarID: avatar.avatarID))
    }

    private func loadAvatarsForCategory() async {
        do {
            // Load avatars for the given category
            avatars = try await avatarManager.getAvatarsForCategory(category: category)
        } catch {
            print("Failed to load avatars for category \(category.rawValue): \(error)")
            showAlert = AnyAppAlert(error: error)
        }
        
        isLoading = false
   }
}

#Preview {
    CategoryListView(path: .constant([]))
        .environment(AvatarManager(remote: MockAvatarService()))
}
