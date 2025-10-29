//
//  ImageLoadView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageLoadView: View {
    var urlString: String = Constants.randomImageURL
    var resizingModel: ContentMode = .fill
    var body: some View {
        Rectangle()
            .fill(.accent.opacity(0.01))
            .overlay {
                WebImage(url: URL(string: urlString))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .aspectRatio(contentMode: resizingModel)
                    .allowsTightening(false)
            }
            .clipped()
    }
}

#Preview {
    ImageLoadView()
        .frame(width: 100, height: 200)
}
