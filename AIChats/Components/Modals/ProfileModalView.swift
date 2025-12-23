//
//  ProfileModalView.swift
//  AIChats
//
//  Created by sinduke on 12/20/25.
//

import SwiftUI

struct ProfileModalView: View {
    var imageName: String? = Constants.randomImageURL
    var title: String? = "Alpha"
    var subtitle: String? = "Alien"
    var headline: String? = "An alien in the park!"
    var onXButtonPressed: () -> Void = { }
    
    var body: some View {
        VStack(spacing: 0) {
            if let imageName {
                ImageLoadView(urlString: imageName, forceTransitionAnimation: true)
                    .aspectRatio(1, contentMode: .fit)
            }
            VStack(alignment: .leading, spacing: 16) {
                if let title {
                    Text(title)
                        .font(.title)
                        .fontWeight(.semibold)
                }
                if let subtitle {
                    Text(subtitle)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                if let headline {
                    Text(headline)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
        }
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
        .overlay(alignment: .topTrailing) {
            Image(systemName: "xmark.circle.fill")
                .font(.title)
                .foregroundColor(.black)
                .padding(4)
                .tappableBackground()
                .anyButton {
                    onXButtonPressed()
                }
                .padding(6)
        }
    }
}

#Preview("Modal w/ image") {
    ZStack {
        Color.black.opacity(0.3)
            .ignoresSafeArea()
        ProfileModalView()
            .padding()
    }
}

#Preview("Modal w/o image") {
    ZStack {
        Color.black.opacity(0.3)
            .ignoresSafeArea()
        ProfileModalView(imageName: nil)
            .padding()
    }
}
