//
//  AnyAppAlert.swift
//  AIChats
//
//  Created by sinduke on 12/20/25.
//

import SwiftUI

struct AnyAppAlert: Identifiable {
    // MARK: - TODO: AnyAppAlert 封装设计说明
    /**
     AnyAppAlert 的设计遵循 SwiftUI 的核心思想：**数据驱动 UI，而不是 View 驱动 UI**。

     ─────────────────────────────
     1️⃣ SwiftUI 官方 API 的共同模式
     ─────────────────────────────
     SwiftUI 在所有“展示型 API”中，统一采用 **数据 / 状态 → UI** 的设计：

     - `.alert(item:)`
       → 用数据触发 Alert 展示

     - `.confirmationDialog(item:)`
       → 用模型描述用户可执行的操作（Actions）

     - `NavigationPath`
       → 用数据描述导航层级与路径

     - `.sheet(item:)`
       → 用可选状态描述展示 / 关闭

     👉 结论：
     SwiftUI 推荐 **传递“意图模型（Intent / State）”，而不是直接传 View**。

     ─────────────────────────────
     2️⃣ 为什么要避免 AnyView
     ─────────────────────────────
     `AnyView` 在 SwiftUI 中是一个明确的“警告信号”，意味着：

     > “我不关心你里面是什么，系统你自己想办法吧。”

     使用 AnyView 的代价包括：
     - ❌ 失去 SwiftUI 的 diff & identity 优化（潜在性能问题）
     - ❌ 调试困难（视图层级被类型擦除）
     - ❌ 生命周期不可预测
     - ❌ 后期跨平台或样式扩展成本极高（iPad / macOS / watchOS）

     👉 因此：
     **AnyView 应该是最后的兜底方案，而不是常规封装手段。**

     ─────────────────────────────
     3️⃣ AnyAppAlert 的设计原则
     ─────────────────────────────
     - Alert / ConfirmationDialog 被视为“呈现意图（Presentation Intent）”
     - AnyAppAlert 只描述：
       • 标题（title）
       • 文案（message）
       • 行为（actions）
       • 呈现方式（alert / confirmation）
     - 不直接携带 View，不依赖 SwiftUI 类型

     这样做的好处：
     - ✅ 完全数据驱动，符合 SwiftUI 哲学
     - ✅ 易测试、易维护、易扩展
     - ✅ 保留 SwiftUI diff / identity 优化
     - ✅ 可自然演进为全局弹窗 / Presenter 系统
     */
    
    let id = UUID()
    let title: String
    let message: String?
    let buttons: () -> AnyView
    
    init(
        title: String,
        message: String? = nil,
        buttons: (() -> AnyView)? = nil
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons ?? {
            AnyView(Button("OK") {
                
            })
        }
    }
    
    init(error: Error) {
        self.init(title: "Error", message: error.localizedDescription, buttons: nil)
    }
}

enum AlertType {
    case alert, confirmationDialog
}

extension View {
    
    @ViewBuilder
    func showCustomAlert(type: AlertType = .alert, _ alert: Binding<AnyAppAlert?>) -> some View {
        switch type {
        case .alert:
            self
                .alert(alert.wrappedValue?.title ?? "", isPresented: Binding(isPresented: alert)) {
                    alert.wrappedValue?.buttons()
                } message: {
                    if let message = alert.wrappedValue?.message {
                        Text(message)
                    }
                }
        case .confirmationDialog:
            self
                .confirmationDialog(alert.wrappedValue?.title ?? "", isPresented: Binding(isPresented: alert)) {
                    alert.wrappedValue?.buttons()
                } message: {
                    if let message = alert.wrappedValue?.message {
                        Text(message)
                    }
                }
        }
        
    }
}
