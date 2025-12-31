//
//  FileManager+EXT.swift
//  AIChats
//
//  Created by sinduke on 12/31/25.
//

import SwiftUI

extension FileManager {
    
    /// 保存 Codable 对象为 .txt（JSON 文本）
    static func saveToDocument<T: Codable>(
        fileName: String,
        value: T?,
        directory: FileManager.SearchPathDirectory = .documentDirectory
    ) throws {
        let url = try fileURL(fileName: fileName, directory: directory)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        let data = try encoder.encode(value)
        try data.write(to: url, options: [.atomic])
    }
    
    /// 从 .txt 读取 Codable 对象
    static func getFromDocument<T: Codable>(
        _ type: T.Type,
        from fileName: String,
        directory: FileManager.SearchPathDirectory = .documentDirectory
    ) throws -> T {
        let url = try FileManager.fileURL(fileName: fileName, directory: directory)
        let data = try Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    // MARK: - Private
    private static func fileURL(
        fileName: String,
        directory: FileManager.SearchPathDirectory
    ) throws -> URL {
        let dirURL = try FileManager.default.url(
            for: directory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        
        return dirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
    }
}
