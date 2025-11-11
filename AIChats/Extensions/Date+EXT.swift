//
//  Date+EXT.swift
//  AIChats
//
//  Created by sinduke on 11/11/25.
//

import SwiftUI

extension Date {
    /// 通过天、小时、分钟添加时间间隔
    func addingTimeInterval(days: Double = 0, hours: Double = 0, minutes: Double = 0) -> Date {
        let total = (days * TimeInterval.day) + (hours * TimeInterval.hour) + (minutes * TimeInterval.minute)
        return self.addingTimeInterval(total)
    }
}
