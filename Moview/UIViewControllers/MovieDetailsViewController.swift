//
//  MovieDetailsViewController.swift
//  Moview
//
//  Created by Mehti Ozkan on 8.04.2021.
//

import UIKit

class MovieDetailsViewController: UIViewController
{
    @IBOutlet var moviePreviewImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var yearAndDurationLabel: UILabel!
    @IBOutlet var imdbScoreLabel: UILabel!
    @IBOutlet var imdbIdLabel: UILabel!
    @IBOutlet var plotTextLabel: UILabel!
    
    private var movieDetails: MovieContent?

    
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
    
    public func setMovieDetails(movieContent: MovieContent)
    {
        movieDetails = movieContent
    }
    
    private func updateMovieDetails()
    {
        titleLabel.text = movieDetails?.movieTitle ?? NSLocalizedString("No title", comment: "")
        genreLabel.text = movieDetails?.genre ?? NSLocalizedString("No title", comment: "")
        imdbScoreLabel.text = movieDetails?.imdbRating ?? NSLocalizedString("Not Rated", comment: "")
        
        let yearString = movieDetails?.yearOfRelease ?? NSLocalizedString("Unknown", comment: "")
        let durationString = movieDetails?.lengthMinutes ?? NSLocalizedString("Unknown", comment: "")
        yearAndDurationLabel.text = ("Year: " + yearString + ", Duration: " + durationString)
        
        let imdbIdString = movieDetails?.imdbId ?? NSLocalizedString("Unknown", comment: "")
        imdbIdLabel.text = ("IMDB ID: " + imdbIdString)
        
        plotTextLabel.text = movieDetails?.longPlot ?? NSLocalizedString("Unawailable", comment: "")
        
        if movieDetails?.posterImage != nil
        {
            setPosterImage(image: movieDetails!.posterImage!)
        }
    }
    
    private func setPosterImage(image: UIImage)
    {
        moviePreviewImage.image = image
    }
    
    
    //MARK: - Notification Methods
    
    @objc func imageDownloadCompleted(notification: Notification)
    {
        if let movieContent = notification.object as? MovieContent
        {
            if movieContent.posterImage != nil && movieContent.imdbId == movieDetails?.imdbId
            {
                setPosterImage(image: movieContent.posterImage!)
            }
        }
    }
    

    //MARK: - IBAction Methods
    
    @IBAction func backButtonPressAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
