//
//  MoviePreviewView.swift
//  Moview
//
//  Created by Mehti Ozkan on 8.04.2021.
//

import UIKit


protocol MoviePreviewViewDelegate
{
    func userTapToSeeMoFullMoviewDetailsFor(movieContent: MovieContent)
}

class MoviePreviewView: UIView
{
    @IBOutlet var previewImage: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    
    private var currentMovieContent: MovieContent?
    public var delegate: MoviePreviewViewDelegate?
    

    public func setMoviePreviewContent(movieContent: MovieContent)
    {
        currentMovieContent = movieContent
        
        movieTitle.text = movieContent.movieTitle ?? NSLocalizedString("No title", comment: "")
        
        if movieContent.posterImage != nil
        {
            setPosterImage(image: movieContent.posterImage!)
        }
    }
    
    public func getMovieContentId() -> String?
    {
        return currentMovieContent?.imdbId
    }
    
    public func setPosterImage(image: UIImage)
    {
        previewImage.image = image
    }
    
    
    //MARK: - IBAction Methods
    
    @IBAction private func userTapGestureAction(_ sender: Any)
    {
        if delegate != nil && currentMovieContent != nil
        {
            delegate?.userTapToSeeMoFullMoviewDetailsFor(movieContent: self.currentMovieContent!)
        }
    }
}
