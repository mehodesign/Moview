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
        let imdbScoreString = NSLocalizedString("IMDB Score", comment: "") + ": " + (currentMovieContentContainer?.movieContent.imdbRating ?? NSLocalizedString("Unknown", comment: ""))
        movieDetailsLabel.text = (yearString + ", " + imdbScoreString)
        
        if currentMovieContentContainer?.posterImage != nil
        {
            moviewPreviewImage.image = currentMovieContentContainer!.posterImage
        }
    }
}
