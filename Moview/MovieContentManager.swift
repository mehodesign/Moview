//
//  MovieContentManager.swift
//  Moview
//
//  Created by Mehti Ozkan on 7.04.2021.
//

import UIKit

class MovieContentManager: NSObject
{
    private var previousSearchResult: [MovieContent] = []
    
    func searchForMovieTitle(searchString: String, _ completion: @escaping (_ success: Bool, _ movieContent: MovieContent?) -> Void)
    {
        //Search for a Movie Title
        if searchString.count > 0
        {
            RequestManager.searchMovieFor(name: searchString) { [self]
                (success, movieSearchresult) in
                
                var movieContent: MovieContent? = nil
                
                if success
                {
                    movieContent = MovieContent(title: movieSearchresult?.title,
                                                 year: movieSearchresult?.year,
                                                 genre: movieSearchresult?.genre,
                                                 duration: movieSearchresult?.duration,
                                                 longPlot: movieSearchresult?.plot,
                                                 shortPlot: movieSearchresult?.plot,
                                                 id: movieSearchresult?.imdbId,
                                                 rating: movieSearchresult?.imdbRating)
                    
                    self.previousSearchResult.append(movieContent!)
                }
                
                DispatchQueue.main.async {
                    completion(success, movieContent)
                }
                
            }
        }
        
        completion(false, nil)
    }
    
    //TODO:Download Movie Poster Image Async
}

struct MovieContent
{
    let movieTitle:String?
    let yearOfRelease:String?
    let lengthMinutes: String?
    let genre: String?
    let shortPlot: String?
    let longPlot:String?
    let imdbId: String?
    let imdbRating: String?
    
    init(title: String?, year: String?, genre: String?, duration:String?, longPlot:String?, shortPlot:String?, id: String?, rating: String?)
    {
        self.movieTitle = title
        self.yearOfRelease = year
        self.genre = genre
        self.lengthMinutes = duration
        self.shortPlot = shortPlot
        self.longPlot = longPlot
        self.imdbId = id
        self.imdbRating = rating
    }
}
