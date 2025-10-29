//
//  TabbarView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct TabbarView: View {
    var body: some View {
        TabView {
            Tab("Explore", systemImage: "house.fill", role: .none) {
                ExploreView()
            }
            Tab("Chats", systemImage: "bubble.left.and.bubble.right.fill", role: .none) {
                ChatsView()
            }
            Tab("Profile", systemImage: "person.circle.fill", role: .none) {
                ProfileView()
            }
            Tab("Search", systemImage: "sparkle.magnifyingglass", role: .search) {
                Text("Search View")
            }
        }
    }
}

#Preview {
    TabbarView()
}
