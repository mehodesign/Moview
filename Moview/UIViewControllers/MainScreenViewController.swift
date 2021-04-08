//
//  MainScreenViewController.swift
//  Moview
//
//  Created by Mehti Ozkan on 7.04.2021.
//

import UIKit


class MainScreenViewController: UtilitiesViewController, MoviePreviewViewDelegate
{
    private let SEGUE_IDENTIFIER_TO_MAIN_SCREEN = "MainScreenToDetailsScreen"
    private let ANIMATION_DURATION = 0.25 //seconds
    private let MOVIE_PREVIEW_FRAME_HEIGHT: CGFloat = 460 //pixels
    
    @IBOutlet var searchFieldBar: UIView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var appLogoImageView: UIImageView!
    @IBOutlet var movieDetailsContainer: UIView!
    
    @IBOutlet var searchBarContainerHeightConstraint: NSLayoutConstraint!
    
    private var moviePreviewView: MoviePreviewView?
    private var movieContentToDisplayDetails: MovieContent?
    private var isDisplayingSearchResult: Bool = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(imageDownloadCompleted), name: NSNotification.Name(rawValue: GlobalConstants.NOTIFICATION_KEY_MOVIE_POSTER_DOWNLOAD_COMPLETED), object: nil)
        
        searchButton.isEnabled = false
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: GlobalConstants.NOTIFICATION_KEY_MOVIE_POSTER_DOWNLOAD_COMPLETED), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        print("--> View Will Appear")
    }
    
    func searchMovieForTitle(title: String)
    {
        //Show Activity Indicator to Notify User
        showProgressView()
        
        //Search Movie for Title
        MovieContentManager.searchForMovieTitle(searchString: title) {
            (success, movieContent) in
            
            self.hideProgressView()
            
            if (success && movieContent != nil)
            {
                self.displaySearchResult(movieDetails: movieContent!)
            }
            else
            {
                //TODO:Show Error Alert
            }
        }
    }
    
    func displaySearchResult(movieDetails: MovieContent)
    {
        if !isDisplayingSearchResult
        {
            //Add Movie Preview View into Search Base View
            addMoviePreviewViewToScreen()
            moviePreviewView?.isHidden = false
            
            //Set Movie Content of Movie Preview View
            moviePreviewView!.setMoviePreviewContent(movieContent: movieDetails)
            
            //Set New Search Base View Height
            searchBarContainerHeightConstraint.constant = (searchFieldBar.frame.size.height + MOVIE_PREVIEW_FRAME_HEIGHT)
            
            UIView.animate(withDuration: ANIMATION_DURATION)
            {
                self.appLogoImageView.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func addMoviePreviewViewToScreen()
    {
        if moviePreviewView == nil
        {
            moviePreviewView = (Bundle.main.loadNibNamed("MoviePreviewView", owner: self, options: nil)?.first as! MoviePreviewView)
            moviePreviewView!.delegate = self
            
            movieDetailsContainer.addSubview(moviePreviewView!)
            
            //Set Dimensions of Preview View
            moviePreviewView!.frame = CGRect(x: 0,
                                            y: searchFieldBar.frame.size.height,
                                            width: searchFieldBar.frame.size.width,
                                            height: MOVIE_PREVIEW_FRAME_HEIGHT)
            
            movieDetailsContainer.addConstraints(getMovieDetailsConstraintsFor(view: moviePreviewView!))
        }
    }
    
    func getMovieDetailsConstraintsFor(view: UIView) -> [NSLayoutConstraint]
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: view , attribute: .top, relatedBy: .equal, toItem: searchFieldBar, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: movieDetailsContainer, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: movieDetailsContainer, attribute: .trailing, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: MOVIE_PREVIEW_FRAME_HEIGHT)
        
        return [topConstraint, leadingConstraint, trailingConstraint, heightConstraint]
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let detailsViewController = segue.destination as? MovieDetailsViewController
        {
            detailsViewController.setMovieDetails(movieContent: movieContentToDisplayDetails!)
        }
    }
    
    
    //MARK: - Notification Methods
    
    @objc func imageDownloadCompleted(notification: Notification)
    {
        if let movieDetails = notification.object as? MovieContent
        {
            if movieDetails.posterImage != nil && moviePreviewView?.getMovieContentId() == movieDetails.imdbId
            {
                moviePreviewView?.setPosterImage(image: movieDetails.posterImage!)
            }
        }
    }
    
    
    //MARK: - IBACtion Methods
    
    @IBAction func searchButtonPressAction(_ sender: Any)
    {
        //TODO:Show Activity Indicator
        
        if let searchString = searchTextField.text
        {
            searchMovieForTitle(title: searchString)
        }
        else
        {
            //TODO:Show Error Alert
        }
    }
    
    @IBAction func searchTextFieldEditingChangedAction(_ textField: UITextField)
    {
        searchButton.isEnabled = ((searchTextField.text?.count ?? 0) > 0)
    }
    
    
    //MARK: - Moview Preview View Delegate Methods
    
    func userTapToSeeMoFullMoviewDetailsFor(movieContent: MovieContent)
    {
        movieContentToDisplayDetails = movieContent
        
        performSegue(withIdentifier: SEGUE_IDENTIFIER_TO_MAIN_SCREEN, sender: self)
    }
    
    
}
