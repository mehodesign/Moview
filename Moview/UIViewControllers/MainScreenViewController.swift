//
//  MainScreenViewController.swift
//  Moview
//
//  Created by Mehti Ozkan on 7.04.2021.
//

import UIKit


class MainScreenViewController: UtilitiesViewController, MoviePreviewViewDelegate, PreviousSearchResultsViewDelegate
{
    private let SEGUE_IDENTIFIER_MAIN_SCREEN_TO_DETAILS_SCREEN = "MainScreenToDetailsScreen"
    private let ANIMATION_DURATION = 0.25 //seconds
    private let MOVIE_PREVIEW_FRAME_HEIGHT: CGFloat = 430 //pixels
    
    @IBOutlet var searchFieldBar: UIView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var appLogoImageView: UIImageView!
    @IBOutlet var movieDetailsContainer: UIView!
    
    @IBOutlet var searchBarContainerHeightConstraint: NSLayoutConstraint!
    
    private var moviePreviewView: MoviePreviewView?
    private var previousSearchResultsView: PreviousSearchResultsView?
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
            //Show Error Alert
            else
            {
                let title = NSLocalizedString("Movie Not Found", comment: "")
                let message = NSLocalizedString("Please search another movie title", comment: "")
                self.showAlertController(title: title, message: message, cancelButton: NSLocalizedString("OK", comment: ""))
            }
        }
    }
    
    func displaySearchResult(movieDetails: MovieContent)
    {
        //Add Movie Preview View into Search Base View
        addMoviePreviewViewToScreen()
        
        //Set Movie Content of Movie Preview View
        moviePreviewView!.setMoviePreviewContent(movieContent: movieDetails)
        
        if !isDisplayingSearchResult
        {
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
            
            movieDetailsContainer.addConstraints(getMovieDetailsConstraintsFor(view: moviePreviewView!))
            movieDetailsContainer.superview?.layoutIfNeeded()
        }
        
        moviePreviewView?.isHidden = false
        previousSearchResultsView?.isHidden = true
    }
    
    func addPreviousSearchResultsViewToScreen()
    {
        if previousSearchResultsView == nil
        {
            previousSearchResultsView = (Bundle.main.loadNibNamed("PreviousSearchResultsView", owner: self, options: nil)?.first as! PreviousSearchResultsView)
            previousSearchResultsView!.delegate = self
            
            movieDetailsContainer.addSubview(previousSearchResultsView!)
            
            movieDetailsContainer.addConstraints(getMovieDetailsConstraintsFor(view: previousSearchResultsView!))
            previousSearchResultsView?.superview?.layoutIfNeeded()
        }
        
        //Refresh Previous Movie Searches Before Showing The View
        previousSearchResultsView?.setPreviousSearchResults(movieContents: MovieContentManager.getPreviousSearchResults())
        
        previousSearchResultsView?.isHidden = false
        moviePreviewView?.isHidden = true
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
            addPreviousSearchResultsViewToScreen()
            searchTextField.text = ""
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
        //Checking Search String is Valid
        if let searchString = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        {
            searchMovieForTitle(title: searchString)
            searchTextField.resignFirstResponder()
        }
        //Show Error Alert
        else
        {
            let title = NSLocalizedString("Search Error", comment: "")
            let message = NSLocalizedString("Please enter a valid movie title to search.", comment: "")
            self.showAlertController(title: title, message: message, cancelButton: NSLocalizedString("OK", comment: ""))
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
        
        performSegue(withIdentifier: SEGUE_IDENTIFIER_MAIN_SCREEN_TO_DETAILS_SCREEN, sender: self)
    }
    
    
    //MARK - Previous Search Results View Delegate Methods
    
    func userDidSelectSearchResult(selectedMovieContent: MovieContent)
    {
        movieContentToDisplayDetails = selectedMovieContent
        
        performSegue(withIdentifier: SEGUE_IDENTIFIER_MAIN_SCREEN_TO_DETAILS_SCREEN, sender: self)
    }
    
}
