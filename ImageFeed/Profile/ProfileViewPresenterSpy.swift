//
//  ProfileViewPresenterSpy.swift
//  ImageFeed
//
//  Created by artem on 02.02.2024.
//

import ImageFeed
import Foundation
import WebKit

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    func updateProfileDetails() -> [String]? {
        return nil
    }
    
    weak var view: ProfileViewControllerProtocol?
    var logoutCalled: Bool = false
    
   
    func avatarURL() -> URL? {
        return nil
    }
    
    func logout() {
    logoutCalled = true
    OAuth2TokenStorage().token = nil
    }
  
    func cleanServicesData() {
    }
    static func clean() {
    }
    
}
