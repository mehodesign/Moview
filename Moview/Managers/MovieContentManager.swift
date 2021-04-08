//
//  MovieContentManager.swift
//  Moview
//
//  Created by Mehti Ozkan on 7.04.2021.
//

import UIKit

class MovieContentManager: NSObject
{
    private var previousSearchResults: [MovieContent] = []
    
    private static let selfInstance = MovieContentManager.init()
    
    
    class func searchForMovieTitle(searchString: String, _ completion: @escaping (_ success: Bool, _ movieContent: MovieContent?) -> Void)
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
                    
                    //Store Search Result to Be Able to List Them Later
                    MovieContentManager.selfInstance.previousSearchResults.append(movieContent!)
                    
                    //Download Movie Poster Image
                    if let imageUrl = movieSearchresult?.posterUrlPath
                    {
                        downloadPosterImageFor(path: imageUrl, movieContent: movieContent!)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(success, movieContent)
                }
                
            }
        }
        
        completion(false, nil)
    }
    
    private class func downloadPosterImageFor(path: String, movieContent: MovieContent)
    {
        //Download Poster Image
        RequestManager.getImageFromURL(path: path) {
            (success, image) in
            
            //Notify UI Image Download Complete
            if success && image != nil
            {
                movieContent.setImage(image: image!)
                
                //Post Notification to Notify UI.
                //I Prefer Notifications Instead of Delegation Here, Because There Can Be Many UI Elements Listening For Image Download Notifications.
                NotificationCenter.default.post(Notification(name: NSNotification.Name(rawValue: GlobalConstants.NOTIFICATION_KEY_MOVIE_POSTER_DOWNLOAD_COMPLETED), object: movieContent))
            }
        }
    }
    
    class func GetPreviousSearchResults() -> [MovieContent]
    {
        return MovieContentManager.selfInstance.previousSearchResults
    }
}

class MovieContent: NSObject
{
    let movieTitle:String?
    let yearOfRelease:String?
    let lengthMinutes: String?
    let genre: String?
    let shortPlot: String?
    let longPlot:String?
    let imdbId: String?
    let imdbRating: String?
    var posterImage: UIImage?
    
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
    
    func setImage(image: UIImage)
    {
        posterImage = image
    }
}
