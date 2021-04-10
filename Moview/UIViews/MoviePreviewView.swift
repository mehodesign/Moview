//
//  MoviePreviewView.swift
//  Moview
//
//  Created by Mehti Ozkan on 8.04.2021.
//

import UIKit


protocol MoviePreviewViewDelegate
{
    func userTapToSeeMoFullMoviewDetailsFor(movieContentContainer: MovieContentContainer)
}

class MoviePreviewView: UIView
{
    @IBOutlet var previewImage: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    
    private var currentMovieContent: MovieContentContainer?
    public var delegate: MoviePreviewViewDelegate?
    

    public func setMoviePreviewContent(movieContentContainer: MovieContentContainer)
    {
        currentMovieContent = movieContentContainer
        
        movieTitle.text = movieContentContainer.movieContent.movieTitle
        
        let posterImage = movieContentContainer.posterImage ?? UIImage(systemName: "questionmark.circle")!
        setPosterImage(image: posterImage)
    }
    
    public func getMovieContentId() -> String?
    {
        return currentMovieContent?.movieContent.imdbId
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
            delegate?.userTapToSeeMoFullMoviewDetailsFor(movieContentContainer: self.currentMovieContent!)
        }
    }
}
