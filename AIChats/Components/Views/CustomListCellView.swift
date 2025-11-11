//
//  CustomListCellView.swift
//  AIChats
//
//  Created by sinduke on 11/10/25.
//

import SwiftUI

struct CustomListCellView: View {
    var imageName: String? = Constants.randomImageURL
    var title: String? = "AlphaGPT"
    var subtitle: String? = "An alien that smiling in the space"
    var body: some View {
        HStack {
            ZStack {
                if let imageName {
                    ImageLoadView(urlString: imageName)
                } else {
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(height: 60)
            .clipShape(.rect(cornerRadius: 16, style: .continuous))
            
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
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .padding(.vertical, 4)
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        VStack {
            CustomListCellView()
            CustomListCellView(imageName: nil)
            CustomListCellView(title: nil)
            CustomListCellView(subtitle: nil)
        }
    }
}
