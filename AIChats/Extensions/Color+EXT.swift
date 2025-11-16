//
//  Color+EXT.swift
//  AIChats
//
//  Created by sinduke on 11/13/25.
//

import SwiftUI

// MARK: - Color Hex Extension

/**
 十六进制颜色扩展
 
 支持以下格式的十六进制颜色字符串：
 
 | 格式       | 示例            | 说明             |
 |-----------|----------------|-----------------|
 | `#RGB`    | `#F0A`         | 简写 3 位（自动扩展为 `#FF00AA`） |
 | `#RGBA`   | `#F0A8`        | 简写 4 位含透明度（扩展为 `#FF00AA88`） |
 | `#RRGGBB` | `#FF00AA`      | 标准 6 位 RGB    |
 | `#RRGGBBAA` | `#FF00AA88`  | 标准 8 位 RGBA   |
 
 ## 使用示例
 ```swift
 // 初始化
 let color1 = Color(hex: "#FF0000")        // 红色
 let color2 = Color(hex: "#F00")           // 红色简写
 let color3 = Color(hex: "#FF000088")      // 半透明红色
 
 // 转换为 Hex
 let hexString = Color.red.toHex()                              // "#FF0000"
 let hexWithAlpha = Color.red.toHex(includeAlpha: true)         // "#FF0000FF"
 let hexShort = Color.red.toHex(useShortFormat: true)           // "#F00"
 ```
 */
extension Color {
    
    // MARK: - Initializers
    
    /// 使用十六进制字符串初始化颜色
    ///
    /// 支持多种格式：`#RGB`、`#RGBA`、`#RRGGBB`、`#RRGGBBAA`
    ///
    /// - Parameter hex: 十六进制颜色字符串，可以包含或不包含 `#` 前缀
    /// - Returns: 如果字符串格式有效则返回 `Color` 实例，否则返回 `nil`
    ///
    /// - Note: 3 位和 4 位的简写格式会自动扩展为 6 位或 8 位
    init?(hex: String) {
        // 1️⃣ 去掉空格与 #
        var sanitizedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        sanitizedHex = sanitizedHex.replacingOccurrences(of: "#", with: "")
        
        // 2️⃣ 处理简写形式 (#RGB / #RGBA)
        if sanitizedHex.count == 3 || sanitizedHex.count == 4 {
            let characters = Array(sanitizedHex)
            sanitizedHex = characters.map { "\($0)\($0)" }.joined()
        }
        
        // 3️⃣ 转为整数值
        var hexValue: UInt64 = 0
        guard Scanner(string: sanitizedHex).scanHexInt64(&hexValue) else { return nil }
        
        // 4️⃣ 根据长度判断是否包含透明度
        let isEightDigitFormat = sanitizedHex.count == 8
        
        let redComponent: Double
        let greenComponent: Double
        let blueComponent: Double
        let alphaComponent: Double
        
        if isEightDigitFormat {
            redComponent   = Double((hexValue & 0xFF000000) >> 24) / 255.0
            greenComponent = Double((hexValue & 0x00FF0000) >> 16) / 255.0
            blueComponent  = Double((hexValue & 0x0000FF00) >> 8) / 255.0
            alphaComponent = Double(hexValue & 0x000000FF) / 255.0
        } else {
            redComponent   = Double((hexValue & 0xFF0000) >> 16) / 255.0
            greenComponent = Double((hexValue & 0x00FF00) >> 8) / 255.0
            blueComponent  = Double(hexValue & 0x0000FF) / 255.0
            alphaComponent = 1.0
        }
        
        self.init(
            red: redComponent,
            green: greenComponent,
            blue: blueComponent,
            opacity: alphaComponent
        )
    }
    
    /// 将颜色转换为十六进制字符串（支持输出 #RRGGBB 或 #RRGGBBAA）
    func toHex(includeAlpha: Bool = false, useShortFormat: Bool = false) -> String {
        let uiColor = UIColor(self)
        
        guard let colorComponents = uiColor.cgColor.components else {
            return "#000000"
        }
        
        // 颜色空间可能是灰度的，安全取值
        let redComponent = Int((colorComponents[safe: 0] ?? 0) * 255)
        let greenComponent = Int((colorComponents[safe: 1] ?? 0) * 255)
        let blueComponent = Int((colorComponents[safe: 2] ?? colorComponents[safe: 0] ?? 0) * 255)
        let alphaComponent = Int(uiColor.cgColor.alpha * 255)
        
        var hexString: String
        if includeAlpha {
            hexString = String(
                format: "#%02X%02X%02X%02X",
                redComponent, greenComponent, blueComponent, alphaComponent
            )
        } else {
            hexString = String(
                format: "#%02X%02X%02X",
                redComponent, greenComponent, blueComponent
            )
        }
        
        // 5️⃣ 尝试简写输出 (#RGB / #RGBA)
        if useShortFormat {
            let hexCharacters = Array(hexString.dropFirst()) // 去掉 '#'
            if hexCharacters.count == 6 || hexCharacters.count == 8 {
                var shortForm = ""
                for index in stride(from: 0, to: hexCharacters.count, by: 2) {
                    if hexCharacters[index] == hexCharacters[index + 1] {
                        shortForm.append(hexCharacters[index])
                    } else {
                        return hexString // 无法简写时直接返回完整形式
                    }
                }
                hexString = "#" + shortForm
            }
        }
        
        return hexString
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
