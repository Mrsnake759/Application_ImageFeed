//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by artem on 02.02.2024.
//

import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssert(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssert(viewController.loadRequestCalled)
    }
    
    func testProgressVisibleWhenItIsEqualToOne() {
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        let configuration = AuthConfiguration.standart
        let authHelper = AuthHelper(configuration: configuration)
        
        let url = authHelper.authURL()
        let urlString = url.absoluteString
        
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [
            URLQueryItem(name: "code", value: "test code"),
        ]
        guard let url = urlComponents.url else { return }
        let authHelper = AuthHelper()
        
        let code = authHelper.code(from: url)

        XCTAssertEqual(code, "test code")
    }
}


   


   
