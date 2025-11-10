//
//  CategoryCellView.swift
//  AIChats
//
//  Created by sinduke on 11/4/25.
//

import SwiftUI

struct CategoryCellView: View {
    var title: String = "Category"
    var imageName: String = Constants.randomImageURL
    var font: Font = .title2
    var cornerRadius: CGFloat = 16.0
    var body: some View {
        ImageLoadView(urlString: imageName)
            .aspectRatio(1, contentMode: .fit)
            .overlay(alignment: .bottomLeading) {
                Text(title)
                    .font(font)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .addingGradientBackgroundForText()
            }
            .clipShape(.rect(cornerRadius: cornerRadius, style: .continuous))
    }
}

#Preview {
    ScrollView {
        CategoryCellView()
            .frame(width: 150)
        CategoryCellView()
            .frame(width: 300)
    }
}
