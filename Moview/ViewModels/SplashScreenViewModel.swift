//
//  SplashScreenViewModel.swift
//  Moview
//
//  Created by Mehti Ozkan on 5.05.2021.
//

import Foundation
import FirebaseRemoteConfig
import RxCocoa
import RxSwift


protocol SplashScreen: class
{
    func showErrorAlertFor(title: String, message: String)
    func passToNextScreen()
}

class SplashScreenViewModel
{
    private let FIREBASE_REMOTE_CONFIG_PARAM_NAME = "loodos_splash_text"
    
    private weak var view: SplashScreen?
    private var connectionService: BaseService?
    
    private var remoteConfig = RemoteConfig.remoteConfig()
    
    public var remoteConfigParameter = BehaviorRelay(value: "")
    public var isConnectionErrorHidden = BehaviorRelay(value: true)
    
    
    init(for view: SplashScreen, service: BaseService)
    {
        self.view = view
        self.connectionService = service
    }
    
    public func applicationWillEnterForeground()
    {
        checkConnectivityAndProceedToMainScreen()
    }
    
    private func checkConnectivityAndProceedToMainScreen()
    {
        //Fetch Firebase Remote Values if Connected to Internet
        if connectionService?.isConnectedToInternet ?? false
        {
            self.isConnectionErrorHidden.accept(true)
            fetchRemoteValues()
        }
        //Show Connection Error Alert & Warning
        else
        {
            self.isConnectionErrorHidden.accept(false)
            
            let title = NSLocalizedString("Connection Error", comment: "")
            let message = NSLocalizedString("Your device is not connected to internet. You need internet connection to be able to use this app.", comment: "")
            self.view?.showErrorAlertFor(title: title, message: message)
        }
    }
    
    private func fetchRemoteValues()
    {
        let defaultValue = [FIREBASE_REMOTE_CONFIG_PARAM_NAME: "..." as NSObject]
        remoteConfig.setDefaults(defaultValue)
        
        remoteConfig.fetch {
            (status, error) in
            
            DispatchQueue.main.async
            { [weak self] in
                //Update Interface
                if error == nil
                {
                    self?.remoteConfig.activate(completion:nil)
                    self?.remoteConfigParameter.accept(self?.remoteConfig.configValue(forKey: self?.FIREBASE_REMOTE_CONFIG_PARAM_NAME).stringValue ?? "")
                    
                    //Start Animation and Pass to Next Screen
                    self?.view?.passToNextScreen()
                }
                //Show Error Alert
                else
                {
                    let title = NSLocalizedString("Remote Config Error", comment: "")
                    let message = NSLocalizedString("Firebase Remote Config fetch failed due to an error.", comment: "")
                    self?.view?.showErrorAlertFor(title: title, message: message)
                }
            }
        }
    }
}
