//
//  IntroView.swift
//  AIChats
//
//  Created by sinduke on 10/30/25.
//

import SwiftUI

struct IntroView: View {
    var body: some View {
        // 构建 AttributedString
        let fullText = "Make your own avatars and chat with them!\n\nHave a real conversation with your AI generated responses."
        
        // 创建 AttributedString 初始
        var attributed = AttributedString(fullText)
        
        // 全局基本字体
        attributed.font = .system(size: 20, weight: .regular, design: .rounded)
        attributed.foregroundColor = .primary
        
        // 给 “avatars” 加粗 + 蓝色
        if let range = attributed.range(of: "avatars") {
            attributed[range].font = .system(size: 22, weight: .bold, design: .rounded)
            attributed[range].foregroundColor = .red
        }
        
        // 给 “real conversation” 斜体 + 绿色
        if let range2 = attributed.range(of: "real conversation") {
            attributed[range2].font = .system(size: 20, weight: .regular, design: .rounded).italic()
            attributed[range2].foregroundColor = .green
        }
        
        // 给整个第二句背景淡黄色
        if let startOfSecond = attributed.range(of: "Have a real conversation")?.lowerBound {
            let endOfText = attributed.endIndex
            let secondRange = startOfSecond..<endOfText
            attributed[secondRange].backgroundColor = Color.yellow.opacity(0.2)
        }
        
        return VStack {
            Text(attributed)
                .multilineTextAlignment(.leading)
                .background(
                    LinearGradient(colors: [.red, .blue],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                        .mask(Text(attributed))
                )
                .frame(maxHeight: .infinity)
                .padding(24)
                .baselineOffset(6) // 微调行间距
            
            NavigationLink {
                ColorView()
            } label: {
                Text("Continue")
                    .callToActionButton()
            }
        }
        .padding(24)
    }
}

#Preview {
    NavigationStack {
        IntroView()
    }
}
