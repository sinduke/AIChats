//
//  ProfanityFilter.swift
//  AIChats
//
//  Created by sinduke on 12/19/25.
//

import SwiftUI

// MARK: - Profanity Filter (defensive, throws)
struct ProfanityFilter {
    
    enum Failure: Error, Equatable {
        case tooShort(min: Int)
        case hit(word: String)
    }
    
    let banned: Set<String>
    let minChars: Int
    
    init(banned: [String], minChars: Int = 3) {
        self.banned = Set(banned.map { $0.lowercased() })
        self.minChars = minChars
    }
    
    /// validate + 映射错误：让你在 View 层决定用什么 Error 类型（更解耦）
    func validate<E: Error>(_ text: String, map: (Failure) -> E) throws {
        do {
            try validate(text)
        } catch let failure as Failure {
            throw map(failure)
        }
    }
    
    /// 核心校验：失败就 throw Failure
    func validate(_ text: String) throws {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= minChars else {
            throw Failure.tooShort(min: minChars)
        }
        
        let normalized = normalize(trimmed)
        
        // 1) token 通道：避免 class -> ass 误伤
        let tokens = normalized
            .split(whereSeparator: { !$0.isLetter && !$0.isNumber })
            .map(String.init)
        
        if let hit = tokens.first(where: { banned.contains($0) }) {
            throw Failure.hit(word: hit)
        }
        
        // 2) 连写通道：拦 f u c k / f**k / fu ck / fuck!
        let squashed = squashToLettersAndDigits(normalized)
        
        if let hit = banned.first(where: { squashed.contains($0) }) {
            // 对容易误伤的短词（如 "ass"）做保护：不在这里直接判死
            if !wouldBeFalsePositiveBySubstring(squashed: squashed, hit: hit) {
                throw Failure.hit(word: hit)
            }
        }
        
        // 3) regex 通道：允许中间插入符号/空格、允许重复拉长
        if let hit = firstRegexHit(in: normalized) {
            throw Failure.hit(word: hit)
        }
    }
    
    // MARK: - Normalization
    private func normalize(_ text: String) -> String {
        var str = text
            .lowercased()
            .folding(options: [.diacriticInsensitive, .widthInsensitive], locale: .current)
        
        let map: [Character: Character] = [
            "@": "a", "4": "a",
            "$": "s", "5": "s",
            "0": "o",
            "1": "i", "!": "i",
            "3": "e",
            "7": "t"
        ]
        
        str = String(str.map { map[$0] ?? $0 })
        str = collapseRepeats(str, maxRepeat: 2)
        return str
    }
    
    private func collapseRepeats(_ text: String, maxRepeat: Int) -> String {
        guard maxRepeat >= 1 else { return text }
        var result: [Character] = []
        var last: Character?
        var count = 0
        
        for chat in text {
            if chat == last {
                count += 1
                if count <= maxRepeat { result.append(chat) }
            } else {
                last = chat
                count = 1
                result.append(chat)
            }
        }
        return String(result)
    }
    
    private func squashToLettersAndDigits(_ text: String) -> String {
        text.filter { $0.isLetter || $0.isNumber }
    }
    
    // MARK: - Regex matching (anti-bypass)
    private func firstRegexHit(in normalized: String) -> String? {
        let parts = banned
            .sorted { $0.count > $1.count }
            .map { buildLoosePattern(for: $0) }
        
        guard !parts.isEmpty else { return nil }
        
        let joined = parts.joined(separator: "|")
        let pattern = #"(?i)(^|[^a-z0-9])(?:"# + joined + #")($|[^a-z0-9])"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let range = NSRange(normalized.startIndex..<normalized.endIndex, in: normalized)
        
        guard let match = regex.firstMatch(in: normalized, range: range) else { return nil }
        
        // 命中的原始片段（可能包含符号），用来推断是哪一个词命中
        let matched = (normalized as NSString).substring(with: match.range)
        
        // 返回“规范词”（fuck/shit/…）
        return banned.first(where: { matched.contains($0.first.map(String.init) ?? "") }) ??
        banned.first(where: { approximateContainsWord(matched, word: $0) })
    }
    
    private func approximateContainsWord(_ matched: String, word: String) -> Bool {
        // 用“压扁”再包含做一次更稳的归因
        let squashed = squashToLettersAndDigits(matched)
        return squashed.contains(word)
    }
    
    private func buildLoosePattern(for word: String) -> String {
        let chars = Array(word)
        guard !chars.isEmpty else { return "" }
        
        return chars
            .map { chat in
                let escaped = NSRegularExpression.escapedPattern(for: String(chat))
                return "\(escaped)+"
            }
            .joined(separator: #"[^a-z0-9]*"#)
    }
    
    // MARK: - False positive guard
    private func wouldBeFalsePositiveBySubstring(squashed: String, hit: String) -> Bool {
        // 只对“容易误伤”的短词做保护（你可以按需扩展）
        let riskyShortWords: Set<String> = ["ass"]
        guard riskyShortWords.contains(hit) else { return false }
        
        // 命中短词并且属于“压扁包含”路径时，可能误伤 class/pass
        // 这种情况交给 token/regex 边界判断，不在这里直接判死
        return squashed.contains(hit)
    }
}
