//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by artem on 02.02.2024.
//

import Foundation
import WebKit

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func avatarURL() -> URL?
    func updateProfileDetails() -> [String]?
    func logout()
    static func clean()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    func avatarURL() -> URL? {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return nil }
        return url
    }
    
    func updateProfileDetails() -> [String]? {
        guard let userName = ProfileService.shared.profile?.name,
              let userLogin = ProfileService.shared.profile?.loginName,
              let userStatus = ProfileService.shared.profile?.bio
        else { return nil }
        
        return [userName, userLogin, userStatus]
    }
    
    func logout() {
        OAuth2TokenStorage().token = nil
        ProfileViewPresenter.clean()
        cleanServicesData()
        view?.switchToSplashViewController()
    }
  
    func cleanServicesData() {
        ImagesListService.shared.clean()
        ProfileService.shared.clean()
        ProfileImageService.shared.clean()
        
    }
    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
}
