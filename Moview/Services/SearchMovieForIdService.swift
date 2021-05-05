//
//  SearchMovieService.swift
//  Moview
//
//  Created by Mehti Ozkan on 3.05.2021.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper


class SearchMovieForIdService: BaseService
{
    func searchMovieFor(id: String, _ completion: @escaping (_ success: Bool, _ result: MovieContent?) -> Void)
    {
        let parameters = [
            "apikey": BaseService.API_KEY,
            "i": id
        ] as [String: AnyObject]
        
        requestWith(url: BaseService.BASE_API_URL, method: .get, parameters: parameters).responseObject
        { (response: DataResponse<MovieSearchResult>) in
            let success = (response.result.isSuccess && response.value?.response == "True")
            var resultMovieContent: MovieContent? = nil
            
            if let searchResult = response.value
            {
                resultMovieContent = self.parseResultsToMovieContent(movieSearchresult: searchResult)
            }
            
            completion(success, resultMovieContent)
        }
    }
}

extension BaseService
{
    func parseResultsToMovieContent(movieSearchresult: MovieSearchResult?) -> MovieContent
    {
        let movieContent = MovieContent(title: movieSearchresult?.title,
                                        year: movieSearchresult?.year,
                                        genre: movieSearchresult?.genre,
                                        duration: movieSearchresult?.duration,
                                        plot: movieSearchresult?.plot,
                                        id: movieSearchresult?.imdbId,
                                        rating: movieSearchresult?.imdbRating,
                                        poster: movieSearchresult?.posterUrlPath)
        
        return movieContent
    }
}

struct MovieSearchResult: Mappable
{
    var response: String?
    var errorMessage: String?
    var title: String?
    var year: String?
    var duration: String?
    var genre: String?
    var plot: String?
    var imdbId: String?
    var imdbRating: String?
    var posterUrlPath: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map)
    {
        response <- map["Response"]
        errorMessage <- map["Error"]
        title <- map["Title"]
        year <- map["Year"]
        duration <- map["Runtime"]
        genre <- map["Genre"]
        plot <- map["Plot"]
        imdbId <- map["imdbID"]
        imdbRating <- map["imdbRating"]
        posterUrlPath <- map["Poster"]
    }
}
