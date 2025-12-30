//
//  FirebaseAuthService.swift
//  AIChats
//
//  Created by sinduke on 12/25/25.
//

import SwiftUI
import FirebaseAuth
import SignInAppleAsync

// 定义一个实现 `AuthService` 协议的结构体，用于封装 Firebase 的认证相关操作
struct FirebaseAuthService: AuthService {
    
    // MARK: - 监听当前认证用户的状态变化
    // 返回一个 AsyncStream，当认证状态发生变化时会向外部发出当前的 UserAuthInfo（或 nil）
    func addAuthenticatedUserListener(onListenerAttached: (any NSObjectProtocol) -> Void) -> AsyncStream<UserAuthInfo?> {
        // 创建并返回一个 AsyncStream，供调用方异步接收用户变化事件
        AsyncStream { continuation in
            // 在 Firebase Auth 上注册一个状态变化监听器（当用户登录/登出时触发）
            let listener = Auth.auth().addStateDidChangeListener { (_, currentUser) in
                // 如果 currentUser 不为 nil，构造 UserAuthInfo 并通过 continuation 发出
                if let user = currentUser {
                    continuation.yield(UserAuthInfo(user: user))
                } else {
                    // 如果没有认证用户，则发出 nil（表示未登录）
                    continuation.yield(nil)
                }
            }
            // 将 listener 传回调用者，以便调用者在适当时机移除监听器
            onListenerAttached(listener)
        }
    }
    
    // MARK: - 获取当前已经认证的用户（同步方法）
    // 返回 UserAuthInfo 或 nil（没有登录用户）
    func getAuthenticatedUser() -> UserAuthInfo? {
        // 访问 Firebase Auth 的当前用户，如果存在则包装为 UserAuthInfo 并返回
        if let user = Auth.auth().currentUser {
            return UserAuthInfo(user: user)
        }
        // 未找到已认证用户时返回 nil
        return nil
    }
    
    // MARK: - 匿名登录
    // 异步地用 Firebase 匿名登录，返回 UserAuthInfo 和是否为新用户的标志
    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        // 直接调用 Firebase 的匿名登录 API，并将返回的 AuthDataResult 转换为 (UserAuthInfo, Bool)
        try await Auth.auth().signInAnonymously().asAuthInfo
    }
    
    // MARK: - 使用 Apple 登录（Sign in with Apple）
    // 该流程包括：获取 Apple 授权信息 => 生成 Firebase OAuth 凭证 => 尝试与当前匿名用户关联或直接登录
    func signInWithApple() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        // 创建用于处理 SignIn With Apple 的辅助对象（封装了 nonce 生成、请求等）
        let helper = SignInWithAppleHelper()
        // 等待用户在 Apple 授权页面完成操作并返回 token + nonce
        let response = try await helper.signIn()
        
        // 使用从 Apple 获取到的 idToken 和 nonce 创建 Firebase OAuth 凭证
        let credential = OAuthProvider.credential(
            providerID: .apple,
            idToken: response.token,
            rawNonce: response.nonce
        )
        
        // 尝试将新凭证与当前匿名用户关联，从而保留匿名数据（如果当前用户存在且为匿名）
//        if let user = Auth.auth().currentUser, user.isAnonymous, let result = try? await user.link(with: credential) {
//            return result.asAuthInfo
//        }
        
        // 下面的代码替代了上面的简洁写法，增加了错误处理逻辑：
        // 如果当前存在匿名用户，尝试 link，如果失败并且错误中包含 UpdatedCredential，使用该凭证登录
        if let user = Auth.auth().currentUser, user.isAnonymous {
            do {
                // 尝试将 Apple 的 credential 关联到当前匿名用户，成功则返回关联后的用户信息
                let result = try await user.link(with: credential)
                return result.asAuthInfo
            } catch let error as NSError {
                /***
                 错误处理注释（中文记忆口诀）：
                 link 失败别急着 signIn
                 先翻 error.userInfo
                 有 UpdatedCredential 就用它
                 */
                // 将 NSError 的 code 转换为 Firebase 的 AuthErrorCode 以便做更细致的分支处理
                let authErrorCode = AuthErrorCode(rawValue: error.code)
                
                // 针对常见的 credentialAlreadyInUse 或 providerAlreadyLinked 错误处理
                switch authErrorCode {
                case .credentialAlreadyInUse, .providerAlreadyLinked:
                    // 当凭证已被其他账户使用时，Firebase 会在 userInfo 中提供一个 UpdatedCredential
                    guard let updatedCredential =
                            error.userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? AuthCredential
                    else {
                        // 如果没有 UpdatedCredential，就把原始错误抛出（作为兜底）
                        throw error // 理论上极少发生，但必须兜底
                    }
                    // 使用 Firebase 提供的“正确 credential”去 signIn（这个 credential 已经是可以用来登录的）
                    let result = try await Auth.auth().signIn(with: updatedCredential)
                    return result.asAuthInfo
                    
                default:
                    // 其他错误直接抛出，交由调用方处理
                    throw error
                }
            }
        }
        // 如果没有匿名用户或关联逻辑没有被走（例如用户不是匿名），则使用 credential 正常登录
        // 注意：使用 Sign in with Apple 需要 Apple 开发者账号配置，否则可能出现错误码 10000
        let result = try await Auth.auth().signIn(with: credential)
        
        // 返回登录结果（UserAuthInfo 和 isNewUser 标志）
        return result.asAuthInfo
    }
    
    // MARK: - 登出操作（同步）
    // 使用 Firebase 的 signOut API 退出当前登录用户（可能抛出异常）
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - 删除当前账户（异步）
    // 删除当前登录用户（需要用户已登录），否则抛出自定义错误
    func deleteAccount() async throws {
        // 确保当前有已登录用户
        guard let user = Auth.auth().currentUser else {
            // 如果没有用户，则抛出自定义的 userNotFound 错误
            throw AuthError.userNotFound
        }
        // 调用 Firebase 的删除接口（异步）
        try await user.delete()
    }
    
    // MARK: - 本地定义的认证错误类型
    enum AuthError: LocalizedError {
        // 当找不到当前用户时使用该错误类型
        case userNotFound
        
        // 为错误提供可本地化的错误描述
        var errorDescription: String? {
            switch self {
            case .userNotFound: "Current User is not found."
            }
        }
    }
}

// MARK: - AuthDataResult 扩展
// 将 Firebase 返回的 AuthDataResult 转换为项目内部使用的 (UserAuthInfo, Bool) 形式
extension AuthDataResult {
    // 计算属性，将 AuthDataResult 映射为元组 (user: UserAuthInfo, isNewUser: Bool)
    var asAuthInfo: (user: UserAuthInfo, isNewUser: Bool) {
        // 使用 AuthDataResult 的 user 构造 UserAuthInfo
        let user = UserAuthInfo(user: user)
        // 通过 additionalUserInfo 的 isNewUser 字段来判断是否是新用户，若缺失则默认 true
        let isNewUser = additionalUserInfo?.isNewUser ?? true
        // 返回结果元组
        return (user, isNewUser)
    }
}
