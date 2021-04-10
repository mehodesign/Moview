//
//  MovieDetailsViewController.swift
//  Moview
//
//  Created by Mehti Ozkan on 8.04.2021.
//

import UIKit
import FirebaseAnalytics


class MovieDetailsViewController: UIViewController
{
    @IBOutlet var moviePreviewImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var yearAndDurationLabel: UILabel!
    @IBOutlet var imdbScoreLabel: UILabel!
    @IBOutlet var imdbIdLabel: UILabel!
    @IBOutlet var plotTextLabel: UILabel!
    
    private var movieDetailsContainer: MovieContentContainer?

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(imageDownloadCompleted), name: NSNotification.Name(rawValue: GlobalConstants.NOTIFICATION_KEY_MOVIE_POSTER_DOWNLOAD_COMPLETED), object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: GlobalConstants.NOTIFICATION_KEY_MOVIE_POSTER_DOWNLOAD_COMPLETED), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        updateMovieDetails()
    }
    
    public func setMovieDetails(movieContentContainer: MovieContentContainer)
    {
        movieDetailsContainer = movieContentContainer
    }
    
    private func updateMovieDetails()
    {
        titleLabel.text = movieDetailsContainer?.movieContent.movieTitle
        genreLabel.text = movieDetailsContainer?.movieContent.genre
        imdbScoreLabel.text = movieDetailsContainer?.movieContent.imdbRating
        
        let yearText = NSLocalizedString("Year", comment: "") + ": " + (movieDetailsContainer?.movieContent.yearOfRelease ?? NSLocalizedString("Unknown", comment: ""))
        let durationText = NSLocalizedString("Duration", comment: "") + ": " + (movieDetailsContainer?.movieContent.lengthMinutes ?? NSLocalizedString("Unknown", comment: ""))
        yearAndDurationLabel.text = yearText + ", " + durationText
        
        imdbIdLabel.text = ("IMDB ID: " + (movieDetailsContainer?.movieContent.imdbId ?? NSLocalizedString("Not Rated", comment: "")))
        
        plotTextLabel.text = movieDetailsContainer?.movieContent.shortPlot
        
        if movieDetailsContainer?.posterImage != nil
        {
            setPosterImage(image: movieDetailsContainer!.posterImage!)
        }
    }
    
    private func setPosterImage(image: UIImage)
    {
        moviePreviewImage.image = image
    }
    
    private func logCurrentMovieDetails()
    {
        if movieDetailsContainer != nil
        {
            FirebaseAnalytics.Analytics.logEvent(AnalyticsEventViewSearchResults, parameters: [
                AnalyticsParameterItemName: movieDetailsContainer!.movieContent.movieTitle,
                AnalyticsParameterItemID: movieDetailsContainer!.movieContent.imdbId,
                AnalyticsParameterContentType: "MovieDetails",
                "year_of_release": movieDetailsContainer!.movieContent.yearOfRelease
            ])
        }
    }
    
    
    //MARK: - Notification Methods
    
    @objc func imageDownloadCompleted(notification: Notification)
    {
        if let movieContentContainer = notification.object as? MovieContentContainer
        {
            if movieContentContainer.posterImage != nil && movieContentContainer.movieContent.imdbId == movieDetailsContainer?.movieContent.imdbId
            {
                setPosterImage(image: movieContentContainer.posterImage!)
            }
        }
    }
    

    //MARK: - IBAction Methods
    
    @IBAction func backButtonPressAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
