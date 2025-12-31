//
//  LocalUserServiceProtocol.swift
//  AIChats
//
//  Created by sinduke on 1/1/26.
//

import SwiftUI

protocol LocalUserServiceProtocol {
    func getCurrentUser() -> UserModel?
    func saveUser(user: UserModel?) throws
}
