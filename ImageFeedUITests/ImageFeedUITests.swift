//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by artem on 02.02.2024.
//

import XCTest
@testable import ImageFeed

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        sleep(5)
        print(webView.buttons)
        
        let loginTextField = webView.descendants(matching: .textField).element
        sleep(5)
        
        loginTextField.tap()
        loginTextField.typeText("<Ваш e-mail>")
        loginTextField.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        sleep(5)
        
        passwordTextField.tap()
        passwordTextField.typeText("<Ваш пароль>")
        webView.swipeUp()
        
        let webViewsQuery = app.webViews
        webViewsQuery.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        sleep(5)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        print(app.debugDescription)
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["likeButton"].tap()
        cellToLike.buttons["likeButton"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["backButton"]
        navBackButtonWhiteButton.tap()
    }
    
    
    func testProfile() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 8))
        
        let profile = app.tabBars.buttons.element(boundBy: 1)
        profile.tap()
        
        XCTAssertTrue(app.staticTexts["Name Lastname"].exists)
        
        XCTAssertTrue(app.staticTexts["@username"].exists)
        
        app.buttons["logoutButton"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Yes"].tap()
        sleep(2)
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
    
}

