//
//  SearchDetailTableViewCell.swift
//  Moview
//
//  Created by Mehti Ozkan on 8.04.2021.
//

import UIKit

class SearchDetailTableViewCell: UITableViewCell
{
    
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieDetailsLabel: UILabel!
    @IBOutlet var moviewPreviewImage: UIImageView!
    
    
    private var currentMovieContentContainer: MovieContentContainer?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(imageDownloadCompleted), name: NSNotification.Name(rawValue: GlobalConstants.NOTIFICATION_KEY_MOVIE_POSTER_DOWNLOAD_COMPLETED), object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: GlobalConstants.NOTIFICATION_KEY_MOVIE_POSTER_DOWNLOAD_COMPLETED), object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setPreviousSearch(movieContentContainer: MovieContentContainer)
    {
        currentMovieContentContainer = movieContentContainer
        
        updateCellDetails()
    }
    
    private func updateCellDetails()
    {
        movieTitleLabel.text = currentMovieContentContainer?.movieContent.movieTitle
        
        let yearString = NSLocalizedString("Year", comment: "") + ": " + (currentMovieContentContainer?.movieContent.yearOfRelease ?? NSLocalizedString("Unknown", comment: ""))
        movieDetailsLabel.text = yearString
        
        setPosterImage(image: currentMovieContentContainer!.posterImage)
    }
    
    private func setPosterImage(image: UIImage?)
    {
        if image != nil
        {
            moviewPreviewImage.image = currentMovieContentContainer!.posterImage
        }
        else
        {
            moviewPreviewImage.image = UIImage(systemName: "questionmark.circle")!
        }
    }
    
    
    //MARK: - Notification Methods
    
    @objc func imageDownloadCompleted(notification: Notification)
    {
        if let movieDetails = notification.object as? MovieContentContainer
        {
            if movieDetails.posterImage != nil && currentMovieContentContainer?.movieContent.imdbId == movieDetails.movieContent.imdbId
            {
                setPosterImage(image: currentMovieContentContainer!.posterImage)
            }
        }
    }
}
