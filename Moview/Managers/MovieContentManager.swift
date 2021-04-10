//
//  MovieContentManager.swift
//  Moview
//
//  Created by Mehti Ozkan on 7.04.2021.
//

import UIKit

class MovieContentManager: NSObject
{
    private var previousSearchResults: [MovieContentContainer] = []
    
    private static let selfInstance = MovieContentManager.init()
    
    
    class func searchForMovieTitle(searchString: String, _ completion: @escaping (_ success: Bool, _ movieContent: MovieContentContainer?, _ error: String?) -> Void)
    {
        //Search for a Movie Title
        if searchString.count > 0
        {
            RequestManager.searchMovieFor(name: searchString) { [self]
                (success, movieSearchresult) in
                
                var movieContentContainer: MovieContentContainer? = nil
                
                if success
                {
                    let movieContent = MovieContent(title: movieSearchresult?.title,
                                                    year: movieSearchresult?.year,
                                                    genre: movieSearchresult?.genre,
                                                    duration: movieSearchresult?.duration,
                                                    plot: movieSearchresult?.plot,
                                                    id: movieSearchresult?.imdbId,
                                                    rating: movieSearchresult?.imdbRating)
                    
                    movieContentContainer = MovieContentContainer(movie: movieContent, poster: nil)
                    
                    //Store Search Result to Be Able to List Them Later
                    MovieContentManager.selfInstance.previousSearchResults.append(movieContentContainer!)
                    
                    //Download Movie Poster Image
                    if let imageUrl = movieSearchresult?.posterUrlPath
                    {
                        downloadPosterImageFor(path: imageUrl, movieContentContainer: movieContentContainer!)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(success, movieContentContainer, movieSearchresult?.errorMessage)
                }
            }
        }
        else
        {
            completion(false, nil, NSLocalizedString("Please enter a valid movie title to search.", comment: ""))
        }
    }
    
    private class func downloadPosterImageFor(path: String, movieContentContainer: MovieContentContainer)
    {
        //Download Poster Image
        RequestManager.getImageFromURL(path: path) {
            (success, image) in
            
            movieContentContainer.posterImage = image
            
            //Notify UI Image Download Complete
            if success && image != nil
            {
                //Post Notification to Notify UI.
                //I Prefer Notifications Instead of Delegation Here, Because There Can Be Many UI Elements Listening For Image Download Notifications.
                NotificationCenter.default.post(Notification(name: NSNotification.Name(rawValue: GlobalConstants.NOTIFICATION_KEY_MOVIE_POSTER_DOWNLOAD_COMPLETED), object: movieContentContainer))
            }
        }
    }
    
    class func getPreviousSearchResults() -> [MovieContentContainer]
    {
        return MovieContentManager.selfInstance.previousSearchResults
    }
}


//MARK: - Movie Content Container Object & Movie Content

class MovieContentContainer: NSObject
{
    let movieContent: MovieContent
    var posterImage: UIImage?
    
    init(movie: MovieContent, poster: UIImage?)
    {
        movieContent = movie
        posterImage = poster
    }
}

struct MovieContent
{
    let movieTitle:String
    let yearOfRelease:String
    let lengthMinutes: String
    let genre: String
    let shortPlot: String
    let imdbId: String
    let imdbRating: String
    
    init(title: String?, year: String?, genre: String?, duration:String?, plot:String?, id: String?, rating: String?)
    {
        self.movieTitle = (title == "N/A" || title == nil) ? NSLocalizedString("No title", comment: "") : title!
        self.yearOfRelease = (year == "N/A" || year == nil) ? NSLocalizedString("Unknown", comment: "") : year!
        self.genre = (genre == "N/A" || genre == nil) ? NSLocalizedString("Unknown", comment: "") : genre!
        self.shortPlot = (plot == "N/A" || plot == nil) ? NSLocalizedString("Unawailable", comment: "") : plot!
        self.imdbId = (id == "N/A" || id == nil) ? NSLocalizedString("Unknown", comment: "") : id!
        self.imdbRating = (rating == "N/A" || rating == nil) ? NSLocalizedString("Not Rated", comment: "") : rating!
        
        let parsedDurationString = (duration == "N/A" || duration == nil) ? NSLocalizedString("Unknown", comment: "") : duration!
        self.lengthMinutes = parsedDurationString.replacingOccurrences(of: "min", with: NSLocalizedString("minutes", comment: ""))
    }
}
