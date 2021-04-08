//
//  UtilitiesViewController.swift
//  Moview
//
//  Created by Mehti Ozkan on 8.04.2021.
//

import UIKit

class UtilitiesViewController: UIViewController
{
    private var progressView: UIView?
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    
    //MARK: - Show/Hide Progress View
    
    func showProgressView()
    {
        if progressView == nil
        {
            progressView = (Bundle.main.loadNibNamed("ProgressView", owner: self, options: nil)?.first as! UIView)
            progressView!.frame = CGRect(x: 0,
                                         y: 0,
                                         width: self.view.frame.size.width,
                                         height: self.view.frame.size.height)
            
            self.view.addSubview(progressView!)
        }
        
        progressView?.isHidden = false
    }
    
    func hideProgressView()
    {
        progressView?.isHidden = true
    }
    
    
    //MARK: - Showing Alert Controller
    
    func showAlertController(title: String, message: String, actionButton: String? = nil, cancelButton: String? = NSLocalizedString("Cancel", comment: ""), actionHandler: ((UIAlertAction) -> Void)? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if actionButton != nil { alertController.addAction(UIAlertAction(title: actionButton, style: .default, handler: actionHandler)) }
        
        if cancelButton != nil { alertController.addAction(UIAlertAction(title: cancelButton, style: .cancel, handler: cancelHandler)) }
        
        self.present(alertController, animated: true, completion: nil)
    }
    

}
