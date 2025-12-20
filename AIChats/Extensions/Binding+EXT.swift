//
//  Binding+EXT.swift
//  AIChats
//
//  Created by sinduke on 12/20/25.
//

import SwiftUI

extension Binding {
    init<T>(isPresented value: Binding<T?>) where Value == Bool {
        self.init(
            get: { value.wrappedValue != nil },
            set: { newValue in
                if !newValue {
                    value.wrappedValue = nil
                }
            }
        )
    }
}
