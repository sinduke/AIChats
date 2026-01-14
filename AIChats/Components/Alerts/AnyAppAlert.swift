//
//  AnyAppAlert.swift
//  AIChats
//
//  Created by sinduke on 12/20/25.
//

import SwiftUI

struct AppAlertButton: Identifiable {
    enum Role {
        case normal
        case cancel
        case destructive
    }

    let id = UUID()
    let title: String
    let role: Role
    let action: () -> Void

    init(_ title: String, role: Role = .normal, action: @escaping () -> Void = {}) {
        self.title = title
        self.role = role
        self.action = action
    }
}

extension AppAlertButton {
    static func ok(_ action: @escaping () -> Void = {}) -> AppAlertButton {
        .init("OK", role: .normal, action: action)
    }

    static func cancel(_ title: String = "Cancel", _ action: @escaping () -> Void = {}) -> AppAlertButton {
        .init(title, role: .cancel, action: action)
    }

    static func destructive(_ title: String, _ action: @escaping () -> Void) -> AppAlertButton {
        .init(title, role: .destructive, action: action)
    }
}

struct AnyAppAlert: Identifiable {
    
    let id = UUID()
    let title: String
    let message: String?
    let buttons: [AppAlertButton]
    
    init(
        title: String,
        message: String? = nil,
        buttons: [AppAlertButton] = [AppAlertButton("OK")]
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }
    
    init(error: Error) {
        self.init(title: "Error", message: error.localizedDescription, buttons: [AppAlertButton("OK")])
    }
}

enum AlertType {
    case alert, confirmationDialog
}

extension View {
    
    @ViewBuilder
    func showCustomAlert(type: AlertType = .alert, _ alert: Binding<AnyAppAlert?>) -> some View {
        
        let isPresented = Binding(
            get: { alert.wrappedValue != nil },
            set: { newValue in
                if !newValue { alert.wrappedValue = nil }
            }
        )
        
        switch type {
        case .alert:
            self.alert(alert.wrappedValue?.title ?? "", isPresented: isPresented) {
                alertButtons(alert.wrappedValue?.buttons ?? [])
            } message: {
                if let message = alert.wrappedValue?.message {
                    Text(message)
                }
            }
            
        case .confirmationDialog:
            self.confirmationDialog(alert.wrappedValue?.title ?? "", isPresented: isPresented) {
                alertButtons(alert.wrappedValue?.buttons ?? [])
            } message: {
                if let message = alert.wrappedValue?.message {
                    Text(message)
                }
            }
        }
    }
    
    @ViewBuilder
    private func alertButtons(_ buttons: [AppAlertButton]) -> some View {
        ForEach(buttons) { item in
            switch item.role {
            case .normal:
                Button(item.title, action: item.action)
            case .cancel:
                Button(item.title, role: .cancel, action: item.action)
            case .destructive:
                Button(item.title, role: .destructive, action: item.action)
            }
        }
    }
}
