//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by artem on 02.02.2024.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    func testProfileViewCallsLogout() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        viewController.configure(presenter)
        
        _ = viewController.showAlert()
        
        XCTAssert(presenter.logoutCalled)
    }
    
    func testProfileViewLogoutTokenIsEqualNil() {
    
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        viewController.configure(presenter)
        
        presenter.logout()
        
        XCTAssertNil(OAuth2TokenStorage().token)
    }
}
