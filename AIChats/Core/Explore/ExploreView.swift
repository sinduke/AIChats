//
//  ExploreView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct ExploreView: View {
    let avatar: AvatarModel = AvatarModel.mock
    var body: some View {
        NavigationStack {
            HeroCellView(title: avatar.name, subtitle: avatar.characterDescription, image: avatar.profileImageName)
                .frame(height: 200)
                .navigationTitle("Explore")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ExploreView()
}
