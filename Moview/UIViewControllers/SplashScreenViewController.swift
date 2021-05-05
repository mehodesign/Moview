//
//  ViewController.swift
//  Moview
//
//  Created by Mehti Ozkan on 7.04.2021.
//

import UIKit
import RxCocoa
import RxSwift


class SplashScreenViewController: UtilitiesViewController, SplashScreen
{
    
    @IBOutlet var connectionErrorBaseView: UIView!
    @IBOutlet var remoteConfigParamLabel: UILabel!
    @IBOutlet var appLogoImage: UIImageView!
    
    private let SEGUE_IDENTIFIER_TO_MAIN_SCREEN = "SplashScreenToMainScreen"
    private let SPLASH_ANIMATION_DURATION = 3.0 //seconds
    
    lazy private var viewModel = SplashScreenViewModel(for: self)
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Listen Application Become Active Events to Check Connection Again
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIScene.willEnterForegroundNotification, object: nil)
        
        bindUiElements()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //Check Connection Status of Device and Pass to Next Screen
        self.viewModel.applicationWillEnterForeground()
    }
    
    func bindUiElements()
    {
        _ = self.viewModel.isConnectionErrorHidden
            .distinctUntilChanged()
            .bind(to: connectionErrorBaseView.rx.isHidden)
            .disposed(by: disposeBag)
        
        _ = self.viewModel.remoteConfigParameter
            .distinctUntilChanged()
            .bind(to: remoteConfigParamLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func showErrorAlertFor(title: String, message: String)
    {
        self.showAlertController(title: title, message: message, cancelButton: NSLocalizedString("OK", comment: ""))
    }

    func passToNextScreen()
    {
        showAppStartingAnimationAndPassToNextScreen()
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
        self.viewModel.applicationWillEnterForeground()
    }

}

