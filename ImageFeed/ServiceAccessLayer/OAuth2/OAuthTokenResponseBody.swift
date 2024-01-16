//
//  OAuthTokenResponseBode.swift
//  ImageFeed
//
//  Created by artem on 16.01.2024.
//

import UIKit

struct OAuthTokenResponseBody: Decodable {
    let access_token: String
    let token_type: String
    let scope: String
    let created_at: Int
}
