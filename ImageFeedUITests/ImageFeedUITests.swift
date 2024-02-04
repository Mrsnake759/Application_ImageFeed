//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by artem on 02.02.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {

        app.buttons["Authenticate"].tap()

        let webView = app.webViews["UnsplashWebView"]
        webView.waitForExistence(timeout: 5)

        let loginTextField = webView.descendants(matching: .textField).element
        loginTextField.waitForExistence(timeout: 5)
        loginTextField.tap()
        loginTextField.typeText("<Ваш e-mail>")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        passwordTextField.waitForExistence(timeout: 5)
        passwordTextField.tap()
        passwordTextField.typeText("<Ваш пароль>")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        webView.swipeUp()

        print(app.debugDescription)
        sleep(3)
        webView.buttons["Login"].tap()

        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }

    func testFeed() throws {

        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        let likeButton = cell.descendants(matching: .button)["LikeButton"]
        cell.waitForExistence(timeout: 5)
        app.swipeUp()
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        likeButton.tap()
        sleep(3)
        
        likeButton.tap()
        sleep(3)
        
        cellToLike.tap()
        sleep(3)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        sleep(3)
        
        image.pinch(withScale: 0.5, velocity: -1)
        
        let backButton = app.buttons["BackButton"]
        backButton.tap()
    }
    
    
    func testProfile() throws {
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        sleep(5)

        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(3)

        XCTAssertTrue(app.staticTexts["Name Lastname"].exists)
        XCTAssertTrue(app.staticTexts["@username"].exists)
        sleep(3)

        app.buttons["LogoutButton"].tap()

        let webView = app.webViews["UnsplashWebView"]
        webView.waitForExistence(timeout: 5)
    }
}
