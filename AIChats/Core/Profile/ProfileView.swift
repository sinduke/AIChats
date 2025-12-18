//
//  ProfileView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var showSettingsView = false
    @State private var showCreateAvatarView: Bool = false
    @State private var currentUser: UserModel? = .mock
//    @State private var myAvatars: [AvatarModel] = AvatarModel.mocks
    @State private var myAvatars: [AvatarModel] = []
    @State private var isLoading: Bool = true
    
    var body: some View {
        NavigationStack {
            List {
                myInfoSection
                myAvatarsSection
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    settingsButton
                }
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
            .fullScreenCover(isPresented: $showCreateAvatarView) {
                CreateAvatarView()
            }
            .task {
                await loadData()
            }
        }
    }

    // MARK: -- View
    private var myInfoSection: some View {
        Section {
            ZStack {
                Circle()
                    .fill(currentUser?.profileColorCalculated ?? .accent)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 100)
                    .frame(maxWidth: .infinity)
            }
        }
        .removeListRowFormatting()
    }
    
    private var myAvatarsSection: some View {
        Section {
            if myAvatars.isEmpty {
                Group {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        Text("You have no avatars yet. Tap the + button to create one.")
                    }
                }
                .foregroundStyle(.secondary)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(myAvatars, id: \.self) { avatar in
                    CustomListCellView(
                        imageName: avatar.profileImageName,
                        title: avatar.name,
                        subtitle: nil
                    )
                }
                .onDelete { indexSet in
                    onDeleteAvatar(at: indexSet)
                }
                .removeListRowFormatting()
            }
        } header: {
            HStack {
                Text("My Avatars")
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.accent)
                    .anyButton {
                        onNewAvatarButtonTapped()
                    }
            }
        }
    }
    
    private var settingsButton: some View {
        
        Image(systemName: "gear")
            .font(.headline)
            .foregroundStyle(.accent)
            .anyButton {
                onSettingButtonTapped()
            }
    }

    // MARK: -- Functions --
    private func loadData() async {
        try? await Task.sleep(for: .seconds(2))
        isLoading = false
        myAvatars = AvatarModel.mocks
    }
    
    private func onSettingButtonTapped() {
        showSettingsView = true
    }
    
    private func onNewAvatarButtonTapped() {
        showCreateAvatarView = true
    }
    
    private func onDeleteAvatar(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        myAvatars.remove(at: index)
    }
}

#Preview {
    ProfileView()
        .environment(AppState())
}
