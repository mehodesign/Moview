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
    
    
    private var currentMovieContent: MovieContent?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setPreviousSearch(movieContent: MovieContent)
    {
        currentMovieContent = movieContent
        
        updateCellDetails()
    }
    
    private func updateCellDetails()
    {
        movieTitleLabel.text = currentMovieContent?.movieTitle ?? NSLocalizedString("No title", comment: "")
        
        let yearString = currentMovieContent?.yearOfRelease ?? NSLocalizedString("Unknown", comment: "")
        let imdbScoreString = currentMovieContent?.imdbRating ?? NSLocalizedString("Not Rated", comment: "")
        movieDetailsLabel.text = (NSLocalizedString("Year", comment: "") +
                                    ": " +
                                    yearString +
                                    ", " +
                                    NSLocalizedString("IMDB Score", comment: "") +
                                    ": " +
                                    imdbScoreString)
        
        if currentMovieContent?.posterImage != nil
        {
            moviewPreviewImage.image = currentMovieContent!.posterImage
        }
    }
}
