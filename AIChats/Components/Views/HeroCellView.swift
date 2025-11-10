//
//  HeroCellView.swift
//  AIChats
//
//  Created by sinduke on 10/31/25.
//

import SwiftUI

struct HeroCellView: View {
    var title: String? = "This is a Title"
    var subtitle: String? = "This is a subtitle for the hero cell view."
    var image: String? = Constants.randomImageURL
    var body: some View {
        ZStack {
            if let image {
                ImageLoadView(urlString: image)
            } else {
                Rectangle()
                    .fill(.gray.opacity(0.3))
            }
        }
        .overlay(alignment: .bottomLeading, content: {
            VStack(alignment: .leading, spacing: 4) {
                if let title {
                    Text(title)
                        .font(.headline)
                }
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                }
            }
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .addingGradientBackgroundForText()
        })
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    ScrollView {
        VStack {
            HeroCellView()
                .frame(width: 300, height: 200)
            HeroCellView()
                .frame(width: 300, height: 400)
            HeroCellView(image: nil)
                .frame(width: 300, height: 200)
            HeroCellView(title: nil)
                .frame(width: 300, height: 200)
            HeroCellView(subtitle: nil)
                .frame(width: 300, height: 200)
        }
        .frame(maxWidth: .infinity)
    }
}
