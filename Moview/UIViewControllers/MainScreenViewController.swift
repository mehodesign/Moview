//
//  MainScreenViewController.swift
//  Moview
//
//  Created by Mehti Ozkan on 7.04.2021.
//

import UIKit


class MainScreenViewController: UIViewController
{
    private let SEGUE_IDENTIFIER_TO_MAIN_SCREEN = "SplashScreenToMainScreen"
    private let ANIMATION_DURATION = 0.25 //seconds
    
    @IBOutlet var searchFieldBar: UIView!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var appLogoImageView: UIImageView!
    
    @IBOutlet var searchBarContainerHeightConstraint: NSLayoutConstraint!
    
    var isDisplayingSearchResult: Bool = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        
    }
    
    func displaySearchResult()
    {
        if !isDisplayingSearchResult
        {
            searchBarContainerHeightConstraint.constant = 400
        
            UIView.animate(withDuration: ANIMATION_DURATION)
            {
                self.appLogoImageView.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //TODO:Pass Movie Details to Next Screen
    }
    
    
    //MARK: - IBACtion Methods
    
    @IBAction func searchButtonPressAction(_ sender: Any)
    {
        displaySearchResult()
    }
    
    @IBAction func searchTextFieldEditingChangedAction(_ searchTextField: UITextField)
    {
        searchButton.isEnabled = ((searchTextField.text?.count ?? 0) > 0)
    }
    
    
}
