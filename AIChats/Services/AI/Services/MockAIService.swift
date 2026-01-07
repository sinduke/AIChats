//
//  MockAIService.swift
//  AIChats
//
//  Created by sinduke on 1/8/26.
//

import SwiftUI

struct MockAIService: AIServiceProtocol {
    func generateImage(from prompt: String) async throws -> UIImage {
        try? await Task.sleep(for: .seconds(3))
        return UIImage(systemName: "pencil")!
    }
}
