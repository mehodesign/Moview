//
//  MoviePreviewView.swift
//  Moview
//
//  Created by Mehti Ozkan on 8.04.2021.
//

import UIKit


protocol MoviePreviewViewDelegate
{
    func userTapToSeeMoFullMoviewDetails()
}

class MoviePreviewView: UIView
{
    @IBOutlet var previewImage: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    
    public var delegate: MoviePreviewViewDelegate?
    

    public func setMoviePreviewContent(movieContent: MovieSearchResult)
    {
        movieTitle.text = movieContent.title ?? NSLocalizedString("No title", comment: "")
        
        //TODO:Set Movie Poster Image
        //previewImage.image =
    }
    
    
    //MARK: - IBAction Methods
    
    @IBAction private func userTapGestureAction(_ sender: Any)
    {
        if delegate != nil
        {
            delegate?.userTapToSeeMoFullMoviewDetails()
        }
    }
}
