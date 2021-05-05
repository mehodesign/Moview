//
//  SearchDetailTableViewCell.swift
//  Moview
//
//  Created by Mehti Ozkan on 8.04.2021.
//

import UIKit

class SearchDetailTableViewCell: UITableViewCell, SearchDetailsCell
{
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieDetailsLabel: UILabel!
    @IBOutlet var moviewPreviewImage: UIImageView!
    
    public private(set) var viewModel: SearchDetailsCellViewModel?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    func setViewModel(_ model: SearchDetailsCellViewModel)
    {
        self.viewModel = model
        
        updateCellDetails()
    }
    
    private func updateCellDetails()
    {
        if let movieContent = self.viewModel?.movieDetails
        {
            movieTitleLabel.text = movieContent.movieTitle
        
            let yearString = NSLocalizedString("Year", comment: "") + ": " + (movieContent.yearOfRelease)
            movieDetailsLabel.text = yearString
            
            //setPosterImage(image: currentMovieContent!.posterImage)
        }
    }
    
    func posterImageDidUpdate(image: UIImage)
    {
        moviewPreviewImage.image = image
    }
    
    /*
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
    */
    
    //MARK: - Notification Methods
    /*
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
     */
}
