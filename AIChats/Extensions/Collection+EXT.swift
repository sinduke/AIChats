//
//  Collection+EXT.swift
//  AIChats
//
//  Created by sinduke on 1/14/26.
//

extension Collection {
    func first(upTo value: Int) -> [Element]? {
        guard !isEmpty else { return nil }
        let maxItem = Swift.min(value, self.count)
        return Array(self.prefix(maxItem))
    }

    func last(upTo value: Int) -> [Element]? {
        guard !isEmpty else { return nil }
        let maxItem = Swift.min(value, self.count)
        return Array(self.suffix(maxItem))
    }
}
