//
//  MovieContainer.swift
//  Moview
//
//  Created by Mehti Ozkan on 3.05.2021.
//

import Foundation

struct MovieContent: Equatable
{
    let movieTitle:String
    let yearOfRelease:String
    let lengthMinutes: String
    let genre: String
    let shortPlot: String
    let imdbId: String
    let imdbRating: String
    let posterImageUrl: String?
    
    init(title: String?, year: String?, genre: String?, duration:String?, plot:String?, id: String?, rating: String?, poster: String?)
    {
        self.movieTitle = (title == "N/A" || title == nil) ? NSLocalizedString("No title", comment: "") : title!
        self.yearOfRelease = (year == "N/A" || year == nil) ? NSLocalizedString("Unknown", comment: "") : year!
        self.genre = (genre == "N/A" || genre == nil) ? NSLocalizedString("Unknown", comment: "") : genre!
        self.shortPlot = (plot == "N/A" || plot == nil) ? NSLocalizedString("Unawailable", comment: "") : plot!
        self.imdbId = (id == "N/A" || id == nil) ? NSLocalizedString("Unknown", comment: "") : id!
        self.imdbRating = (rating == "N/A" || rating == nil) ? NSLocalizedString("Not Rated", comment: "") : rating!
        
        let parsedDurationString = (duration == "N/A" || duration == nil) ? NSLocalizedString("Unknown", comment: "") : duration!
        self.lengthMinutes = parsedDurationString.replacingOccurrences(of: "min", with: NSLocalizedString("minutes", comment: ""))
        
        self.posterImageUrl = (poster == "N/A") ? nil : poster
    }
}
