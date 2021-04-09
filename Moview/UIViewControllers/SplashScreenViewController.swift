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
    @IBOutlet var appLogoImage: UIImageView!
    
    
    private let SEGUE_IDENTIFIER_TO_MAIN_SCREEN = "SplashScreenToMainScreen"
    private let FIREBASE_REMOTE_CONFIG_PARAM_NAME = "loodos_splash_text"
    private let SPLASH_ANIMATION_DURATION = 3.0 //seconds
    
    
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
    
    private func checkConnectivityAndProceedToMainScreen()
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
    
    private func fetchRemoteValues()
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
    
    private func showAppStartingAnimationAndPassToNextScreen()
    {
        //End Listening Application Become Active Events
        NotificationCenter.default.removeObserver(self, name: UIScene.willEnterForegroundNotification, object: nil)
        
        startSplashAnimationToPassNextScreen()
    }
    
    private func startSplashAnimationToPassNextScreen()
    {
        let circleImage = UIImageView(image: UIImage(systemName: "circle.fill"))
        circleImage.alpha = 0
        circleImage.frame = appLogoImage.frame
        
        self.view.addSubview(circleImage)
        
        UIView.animateKeyframes(withDuration: SPLASH_ANIMATION_DURATION, delay: 0, options: .calculationModeLinear)
        {
            //Logo Expands
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7) {
                self.appLogoImage.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            
            //Logo Pops
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.1) {
                self.appLogoImage.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
            //Circle Becomes Visible
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.01) {
                circleImage.alpha = 1
            }
            
            //Circle Wave Disappears
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3) {
                circleImage.alpha = 0
                circleImage.transform = CGAffineTransform(translationX: self.view.center.x, y: self.view.center.y)
                circleImage.transform = CGAffineTransform(scaleX: 20, y: 20)
            }
            
        } completion: {
            (complete) in
            
            //Proceed to Main Screen
            self.performSegue(withIdentifier: self.SEGUE_IDENTIFIER_TO_MAIN_SCREEN, sender: self)
        }
    }

    
    //MARK: - Notification Methods
    
    @objc func applicationWillEnterForeground(notification: Notification)
    {
        checkConnectivityAndProceedToMainScreen()
    }

}

