//
//  OAuth2Storage.swift
//  ImageFeed
//
//  Created by artem on 14.01.2024.
//

import Foundation

final class OAuth2TokenStorage {
    private let tokenKey = "token"

    var token: String? {
        get {
            UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
}
