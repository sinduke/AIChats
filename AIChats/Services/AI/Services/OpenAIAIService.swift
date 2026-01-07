//
//  OpenAIAIService.swift
//  AIChats
//
//  Created by sinduke on 1/8/26.
//

import SwiftUI
import OpenAI

struct OpenAIAIService: AIServiceProtocol {
    
    var openAI: OpenAI {
        OpenAI(
            configuration: .init(
                token: Keys.openAIAPIKey,
                host: Keys.openAIAPIHost,
                scheme: "https",
                basePath: "/v1"
            )
        )
    }
    
    func generateImage(from prompt: String) async throws -> UIImage {
        let query = ImagesQuery(
            prompt: prompt,
            model: .dall_e_3, // 使用的模型可选
            n: 1, // 图片的数量 可选
            quality: .hd, // 图片的质量 可选
            responseFormat: .b64_json, // 响应格式 可选
            size: ._1024, // 图片尺寸 可选
            style: .natural, // 图片风格 可选
            user: nil // 用户标识符 可选
        )
        
        let result = try await openAI.images(query: query)
        
        guard let b64Json = result.data.first?.b64Json,
              let imageData = Data(base64Encoded: b64Json),
              let image = UIImage(data: imageData) else {
            throw AIServiceError.invalidResponse
        }
        
        return image
        
    }
    
    enum AIServiceError: LocalizedError {
        case invalidResponse
    }
}
