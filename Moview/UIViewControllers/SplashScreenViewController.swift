//
//  ViewController.swift
//  Moview
//
//  Created by Mehti Ozkan on 7.04.2021.
//

import UIKit

class SplashScreenViewController: UIViewController
{
    private let SEGUE_IDENTIFIER_TO_MAIN_SCREEN = "SplashScreenToMainScreen"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //TODO: Check Connection Status of Device
        if RequestManager.isConnectedToInternet
        {
            //TODO:Pass to Next Screen
        }
        else
        {
            //TODO:Show Connection Error
        }
    }


}

