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
}
