//
//  Constants.swift
//  ImageFeed
//
//  Created by artem on 14.01.2024.
//

import Foundation

enum Constants {
    static let AccessKey = "POJIVWCmE2Wa5nEaJjKwwqApC8ox_1gc5T2FpOWzbAE"
    static let SecretKey = "xu7bekSnf65b-QWl8K3zRLXSYDFLdkSbngerLpNtMjA"
    static let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let AccessScope = "public+read_user+write_likes"
    static let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let UnsplashAuthorizeURL = "https://unsplash.com/oauth/authorize"
}
