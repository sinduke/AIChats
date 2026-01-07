//
//  AIServiceProtocol.swift
//  AIChats
//
//  Created by sinduke on 1/8/26.
//

import SwiftUI

protocol AIServiceProtocol {
    func generateImage(from prompt: String) async throws -> UIImage
}
