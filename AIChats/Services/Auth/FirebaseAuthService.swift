//
//  FirebaseAuthService.swift
//  AIChats
//
//  Created by sinduke on 12/25/25.
//

import SwiftUI
import FirebaseAuth
import SignInAppleAsync

extension EnvironmentValues {
    @Entry var authService: FirebaseAuthService = FirebaseAuthService()
}

struct FirebaseAuthService {
    
    func getAuthenticatedUser() -> UserAuthInfo? {
        if let user = Auth.auth().currentUser {
            return UserAuthInfo(user: user)
        }
        return nil
    }
    
    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        try await Auth.auth().signInAnonymously().asAuthInfo
    }
    
    func signInWithApple() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        let helper = SignInWithAppleHelper()
        let response = try await helper.signIn()
        
        let credential = OAuthProvider.credential(
            providerID: .apple,
            idToken: response.token,
            rawNonce: response.nonce
        )
        
        // Try to link to existing anonymous account
//        if let user = Auth.auth().currentUser, user.isAnonymous, let result = try? await user.link(with: credential) {
//            return result.asAuthInfo
//        }
        if let user = Auth.auth().currentUser, user.isAnonymous {
            do {
                let result = try await user.link(with: credential)
                return result.asAuthInfo
            } catch let error as NSError {
                /**
                 “记忆口诀”
                 link 失败别急着 signIn
                 先翻 error.userInfo
                 有 UpdatedCredential 就用它
                 */
                let authErrorCode = AuthErrorCode(rawValue: error.code)
                
                switch authErrorCode {
                case .credentialAlreadyInUse, .providerAlreadyLinked:
                    guard let updatedCredential =
                            error.userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? AuthCredential
                    else {
                        throw error // 理论上极少发生，但必须兜底
                    }
                    // 用 Firebase 给你的“正确 credential”登录
                    let result = try await Auth.auth().signIn(with: updatedCredential)
                    return result.asAuthInfo
                    
                default:
                    break
                }
            }
        }
        // 这里需要苹果开发者账号才会出现SignInWithApple 否则报错10000
        // Sign in normally
        let result = try await Auth.auth().signIn(with: credential)
        
        return result.asAuthInfo
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        try await user.delete()
    }
    
    enum AuthError: LocalizedError {
        case userNotFound
        
        var errorDescription: String? {
            switch self {
            case .userNotFound: "Current User is not found."
            }
        }
    }
}

extension AuthDataResult {
    var asAuthInfo: (user: UserAuthInfo, isNewUser: Bool) {
        let user = UserAuthInfo(user: user)
        let isNewUser = additionalUserInfo?.isNewUser ?? true
        return (user, isNewUser)
    }
}
