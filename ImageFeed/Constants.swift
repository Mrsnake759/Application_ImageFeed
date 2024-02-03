//
//  Constants.swift
//  ImageFeed
//
//  Created by artem on 14.01.2024.
//

import Foundation

let AccessKey = "POJIVWCmE2Wa5nEaJjKwwqApC8ox_1gc5T2FpOWzbAE"
let SecretKey = "xu7bekSnf65b-QWl8K3zRLXSYDFLdkSbngerLpNtMjA"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURL = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 defaultBaseURL: DefaultBaseURL,
                                 authURLString: UnsplashAuthorizeURL)
    }
}
