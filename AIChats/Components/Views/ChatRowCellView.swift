//
//  ChatRowCellView.swift
//  AIChats
//
//  Created by sinduke on 11/11/25.
//

import SwiftUI

struct ChatRowCellView: View {
    var imageName: String? = Constants.randomImageURL
    var headline: String? = "Chat Title"
    var subheadline: String? = "Last message preview goes here."
    var hasNewMessage: Bool = true
    
    var body: some View {
        HStack {
            ZStack {
                if let imageName {
                    ImageLoadView(urlString: imageName)
                } else {
                    Rectangle()
                        .fill(.secondary.opacity(0.5))
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(.circle)
            
            VStack(alignment: .leading, spacing: 4) {
                if let headline {
                    Text(headline)
                        .font(.headline)
                }
                if let subheadline {
                    Text(subheadline)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if hasNewMessage {
                Text("New")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 8)
                    .background(.accent)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 4, style: .continuous))
            }
                    
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(Color(.systemBackground))
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        List {
            Section {
                ChatRowCellView(imageName: nil)
                ChatRowCellView(headline: nil)
                ChatRowCellView(subheadline: nil)
                ChatRowCellView(hasNewMessage: false)
                ChatRowCellView(headline: "Long Headline Example That Might Overflow", subheadline: "This is a very long subheadline that is supposed to demonstrate how the text truncation works in the chat row cell view component.", hasNewMessage: true)
            }
            .removeListRowFormatting()
        }
    }
}
