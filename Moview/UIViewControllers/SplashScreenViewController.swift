//
//  ViewController.swift
//  Moview
//
//  Created by Mehti Ozkan on 7.04.2021.
//

import UIKit
import FirebaseRemoteConfig


class SplashScreenViewController: UtilitiesViewController
{
    @IBOutlet var connectionErrorBaseView: UIView!
    @IBOutlet var remoteConfigParamLabel: UILabel!
    
    private let SEGUE_IDENTIFIER_TO_MAIN_SCREEN = "SplashScreenToMainScreen"
    private let FIREBASE_REMOTE_CONFIG_PARAM_NAME = "loodos_splash_text"
    
    var remoteConfig = RemoteConfig.remoteConfig()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Listen Application Become Active Events to Check Connection Again
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIScene.willEnterForegroundNotification, object: nil)
        
        connectionErrorBaseView.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //Check Connection Status of Device and Pass to Next Screen
        checkConnectivityAndProceedToMainScreen()
    }
    
    func checkConnectivityAndProceedToMainScreen()
    {
        //Fetch Firebase Remote Values if Connected to Internet
        if RequestManager.isConnectedToInternet
        {
            fetchRemoteValues()
        }
        //Show Connection Error Alert & Warning
        else
        {
            connectionErrorBaseView.isHidden = false
            
            let title = NSLocalizedString("Connection Error", comment: "")
            let message = NSLocalizedString("Your device is not connected to internet. You need internet connection to be able to use this app.", comment: "")
            self.showAlertController(title: title, message: message, cancelButton: NSLocalizedString("OK", comment: ""))
        }
    }
    
    func fetchRemoteValues()
    {
        let defaultValue = [FIREBASE_REMOTE_CONFIG_PARAM_NAME: "..." as NSObject]
        remoteConfig.setDefaults(defaultValue)
        
        remoteConfig.fetch {
            (status, error) in
            
            DispatchQueue.main.async {
                //Update Interface
                if error == nil
                {
                    self.remoteConfig.activate(completion:nil)
                    self.remoteConfigParamLabel.text = self.remoteConfig.configValue(forKey: self.FIREBASE_REMOTE_CONFIG_PARAM_NAME).stringValue ?? ""
                    
                    //Start Animation and Pass to Next Screen
                    self.showAppStartingAnimationAndPassToNextScreen()
                }
                //Show Error Alert
                else
                {
                    let title = NSLocalizedString("Remote Config Error", comment: "")
                    let message = NSLocalizedString("Firebase Remote Config fetch failed due to an error.", comment: "")
                    self.showAlertController(title: title, message: message, cancelButton: NSLocalizedString("OK", comment: ""))
                }
            }
        }
    }
    
    func showAppStartingAnimationAndPassToNextScreen()
    {
        //End Listening Application Become Active Events
        NotificationCenter.default.removeObserver(self, name: UIScene.willEnterForegroundNotification, object: nil)
        
        //Proceed to Main Screen
        performSegue(withIdentifier: SEGUE_IDENTIFIER_TO_MAIN_SCREEN, sender: self)
    }

    
    //MARK: - Notification Methods
    
    @objc func applicationWillEnterForeground(notification: Notification)
    {
        checkConnectivityAndProceedToMainScreen()
    }

}

