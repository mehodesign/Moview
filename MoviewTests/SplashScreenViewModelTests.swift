//
//  SplashScreenViewModelTests.swift
//  MoviewTests
//
//  Created by Mehti Ozkan on 7.05.2021.
//

import XCTest
@testable import Moview

class SplashScreenViewModelTests: XCTestCase
{
    private let viewController = MockSplashScreenViewController()
    private let baseService = MockBaseService()

    func testing_splash_screen_view_model_initialization()
    {
        let viewModel = SplashScreenViewModel(for: viewController, service: baseService)
        
        XCTAssertTrue(viewModel.isConnectionErrorHidden.value)
        XCTAssertTrue(viewModel.remoteConfigParameter.value.isEmpty)
    }

    func testing_successful_connection()
    {
        let viewModel = SplashScreenViewModel(for: viewController, service: baseService)
        baseService.connectionValue = true
        viewModel.applicationWillEnterForeground()
        
        XCTAssertTrue(viewModel.isConnectionErrorHidden.value)
        XCTAssertNil(viewController.errorTitle)
        XCTAssertNil(viewController.errorMessage)
    }
    
    func testing_failed_connection()
    {
        let viewModel = SplashScreenViewModel(for: viewController, service: baseService)
        baseService.connectionValue = false
        viewModel.applicationWillEnterForeground()
        
        XCTAssertFalse(viewModel.isConnectionErrorHidden.value)
        XCTAssertNotNil(viewController.errorTitle)
        XCTAssertNotNil(viewController.errorMessage)
        XCTAssertEqual(viewController.errorTitle, NSLocalizedString("Connection Error", comment: ""))
        XCTAssertEqual(viewController.errorMessage, NSLocalizedString("Your device is not connected to internet. You need internet connection to be able to use this app.", comment: ""))
    }
}

private class MockSplashScreenViewController: SplashScreen
{
    var errorTitle: String?
    var errorMessage: String?
    var isPassingToNextScreen: Bool = false
    
    func showErrorAlertFor(title: String, message: String)
    {
        self.errorTitle = title
        self.errorMessage = message
    }
    
    func passToNextScreen()
    {
        self.isPassingToNextScreen = true
    }
}

private class MockBaseService: BaseService
{
    var connectionValue: Bool = true
    
    override var isConnectedToInternet: Bool {
        return connectionValue
    }
}
