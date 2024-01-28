//
//  ProfileServiceResponceBody.swift
//  ImageFeed
//
//  Created by artem on 22.01.2024.
//

import UIKit

struct ProfileResult: Decodable {
    let username: String
    let first_name: String
    let last_name: String?
    let bio: String?
}
