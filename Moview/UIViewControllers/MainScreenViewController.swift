//
//  MainScreenViewController.swift
//  Moview
//
//  Created by Mehti Ozkan on 7.04.2021.
//

import UIKit


class MainScreenViewController: UtilitiesViewController, MoviePreviewViewDelegate, PreviousSearchResultsViewDelegate, UITextFieldDelegate
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
    
    private lazy var moviePreviewView: MoviePreviewView = (Bundle.main.loadNibNamed("MoviePreviewView", owner: self, options: nil)?.first as! MoviePreviewView)
    private lazy var previousSearchResultsView: PreviousSearchResultsView = (Bundle.main.loadNibNamed("PreviousSearchResultsView", owner: self, options: nil)?.first as! PreviousSearchResultsView)
    private var movieContentToDisplayDetails: MovieContentContainer?
    private var isDisplayingSearchResult: Bool = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(imageDownloadCompleted), name: NSNotification.Name(rawValue: GlobalConstants.NOTIFICATION_KEY_MOVIE_POSTER_DOWNLOAD_COMPLETED), object: nil)
        
        moviePreviewView.delegate = self
        previousSearchResultsView.delegate = self
        
        searchButton.isEnabled = false
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: GlobalConstants.NOTIFICATION_KEY_MOVIE_POSTER_DOWNLOAD_COMPLETED), object: nil)
    }
    
    private func searchMovieForTitle(title: String)
    {
        //Show Activity Indicator to Notify User
        showProgressView()
        
        //Search Movie for Title
        MovieContentManager.searchMoviesFor(searchString: title) {
            (success, movieContentList, error) in
            
            self.hideProgressView()
            
            if (success && movieContentList.count > 0)
            {
                self.displaySearchResults()
                
                if movieContentList.count == 1
                {
                    self.addMoviePreviewViewToScreen(movieContentContainer: movieContentList[0])
                }
                else
                {
                    self.addSearchResultsViewToScreen(movieContentList)
                }
            }
            //Show Error Alert
            else
            {
                self.hideSearchResults()
                let title = NSLocalizedString("Movie Not Found", comment: "")
                let message = NSLocalizedString("Please search another movie title", comment: "")
                self.showAlertController(title: title, message: message, cancelButton: NSLocalizedString("OK", comment: ""))
            }
        }
    }
    
    private func hideSearchResults()
    {
        moviePreviewView.isHidden = true
        previousSearchResultsView.isHidden = true
    }
    
    private func displaySearchResults()
    {
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
    
    private func addMoviePreviewViewToScreen(movieContentContainer: MovieContentContainer)
    {
        if moviePreviewView.superview == nil
        {
            movieDetailsContainer.addSubview(moviePreviewView)
            movieDetailsContainer.addConstraints(getMovieDetailsConstraintsFor(view: moviePreviewView))
            movieDetailsContainer.superview?.layoutIfNeeded()
        }
        
        //Set Movie Content of Movie Preview View
        moviePreviewView.setMoviePreviewContent(movieContentContainer: movieContentContainer)
        
        moviePreviewView.isHidden = false
        previousSearchResultsView.isHidden = true
    }
    
    private func addSearchResultsViewToScreen(_ resultList: [MovieContentContainer])
    {
        if previousSearchResultsView.superview == nil
        {
            movieDetailsContainer.addSubview(previousSearchResultsView)
            movieDetailsContainer.addConstraints(getMovieDetailsConstraintsFor(view: previousSearchResultsView))
            previousSearchResultsView.superview?.layoutIfNeeded()
        }
        
        //Refresh Previous Movie Searches Before Showing The View
        previousSearchResultsView.setPreviousSearchResults(movieContents: resultList)
        previousSearchResultsView.isHidden = false
        moviePreviewView.isHidden = true
    }
    
    private func getMovieDetailsConstraintsFor(view: UIView) -> [NSLayoutConstraint]
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: view , attribute: .top, relatedBy: .equal, toItem: searchFieldBar, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: movieDetailsContainer, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: movieDetailsContainer, attribute: .trailing, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: MOVIE_PREVIEW_FRAME_HEIGHT)
        
        return [topConstraint, leadingConstraint, trailingConstraint, heightConstraint]
    }
    
    private func isValidSearchString(searchString: String?) -> Bool
    {
        return (searchString?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0)
    }
    
    private func passToMovieDetailsScreen(selectedMovieContentContainer: MovieContentContainer)
    {
        showProgressView()
        
        MovieContentManager.searchForMovieContainer(container: selectedMovieContentContainer) {
            (succes, movieContainer, error) in
            
            //Show Movie Details Anyway
            DispatchQueue.main.async {
                self.hideProgressView()
                self.movieContentToDisplayDetails = movieContainer
                self.performSegue(withIdentifier: self.SEGUE_IDENTIFIER_MAIN_SCREEN_TO_DETAILS_SCREEN, sender: self)
            }
        }
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let detailsViewController = segue.destination as? MovieDetailsViewController
        {
            detailsViewController.setMovieDetails(movieContentContainer: movieContentToDisplayDetails!)
            searchTextField.text = ""
        }
    }
    
    
    //MARK: - Notification Methods
    
    @objc func imageDownloadCompleted(notification: Notification)
    {
        if let movieDetails = notification.object as? MovieContentContainer
        {
            if movieDetails.posterImage != nil && moviePreviewView.getMovieContentId() == movieDetails.movieContent.imdbId
            {
                moviePreviewView.setPosterImage(image: movieDetails.posterImage!)
            }
        }
    }
    
    
    //MARK: - IBACtion Methods
    
    @IBAction func searchButtonPressAction(_ sender: Any)
    {
        //Checking Search String is Valid
        if isValidSearchString(searchString: searchTextField.text)
        {
            searchMovieForTitle(title: searchTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
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
        searchButton.isEnabled = isValidSearchString(searchString: searchTextField.text)
    }
    
    @IBAction func userTapToScreenGestureRecogniserAction(_ sender: Any)
    {
        searchTextField.resignFirstResponder()
    }
    
    
    //MARK: - Moview Preview View Delegate Methods
    
    func userTapToSeeMoFullMoviewDetailsFor(movieContentContainer: MovieContentContainer)
    {
        passToMovieDetailsScreen(selectedMovieContentContainer: movieContentContainer)
    }
    
    
    //MARK - Previous Search Results View Delegate Methods
    
    func userDidSelectSearchResult(selectedMovieContentContainer: MovieContentContainer)
    {
        passToMovieDetailsScreen(selectedMovieContentContainer: selectedMovieContentContainer)
    }
    
    
    //MARK: - Text field Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        searchButtonPressAction(searchButton)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        hideSearchResults()
        return true
    }
}
