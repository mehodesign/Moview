//
//  SearchDetailsCellViewModel.swift
//  Moview
//
//  Created by Mehti Ozkan on 4.05.2021.
//

import Foundation
import UIKit


protocol SearchDetailsCell
{
    func posterImageDidUpdate(image: UIImage)
}

class SearchDetailsCellViewModel
{
    private var view: SearchDetailsCell?
    private var posterManager: MoviePosterManager = MoviePosterManager.shared
    public private(set) var movieDetails: MovieContent
    public private(set) var posterImage: UIImage?
    
    init(with cellView: SearchDetailsCell, movie: MovieContent)
    {
        self.view = cellView
        self.movieDetails = movie
        
        downloadPosterImage()
    }
    
    public func downloadPosterImage()
    {
        if let posterUrl = self.movieDetails.posterImageUrl
        {
            MoviePosterManager.shared.downloadPosterForMovie(id: self.movieDetails.imdbId, posterUrl: posterUrl)
            { [weak self] (success, id, image) in
                self?.posterImage = image
                
                if image != nil
                {
                    self?.view?.posterImageDidUpdate(image: image!)
                }
            }
        }
    }
}
