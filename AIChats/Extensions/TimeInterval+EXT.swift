//
//  TimeInterval.swift
//  AIChats
//
//  Created by sinduke on 11/11/25.
//

import SwiftUI

extension TimeInterval {
    /// 秒
    static var second: TimeInterval { 1 }
    /// 分钟
    static var minute: TimeInterval { 60 }
    /// 小时
    static var hour: TimeInterval { 3600 }
    /// 天
    static var day: TimeInterval { 86400 }
    
    var seconds: TimeInterval { self }
    var minutes: TimeInterval { self * .minute }
    var hours: TimeInterval { self * .hour }
    var days: TimeInterval { self * .day }
}
