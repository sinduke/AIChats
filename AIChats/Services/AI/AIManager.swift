//
//  AIManager.swift
//  AIChats
//
//  Created by sinduke on 1/1/26.
//

import SwiftUI

@Observable
final class AIManager {
    private let service: AIServiceProtocol
    
    init(service: AIServiceProtocol) {
        self.service = service
    }
    
    func generateImage(from prompt: String) async throws -> UIImage {
        try await service.generateImage(from: prompt)
    }
    
}
