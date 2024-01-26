//
//  OAuth2Storage.swift
//  ImageFeed
//
//  Created by artem on 14.01.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static private let bearerTokenKey = "imageFeedBearerToken"
    static var token: String? {
        get {
            let token: String? = KeychainWrapper.standard.string(forKey: OAuth2TokenStorage.bearerTokenKey)
            return token
        }
        set {
            KeychainWrapper.standard.set(newValue!, forKey: OAuth2TokenStorage.bearerTokenKey)
        }
    }
}

