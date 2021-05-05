//
//  SearchMoviesForNameService.swift
//  Moview
//
//  Created by Mehti Ozkan on 3.05.2021.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper


class SearchMoviesForNameService: BaseService
{
    func searchMoviesFor(name: String, _ completion: @escaping (_ success: Bool, _ result: [MovieContent]) -> Void)
    {
        let parameters = [
            "apikey": BaseService.API_KEY,
            "s": name
        ] as [String: AnyObject]
        
        requestWith(url: BaseService.BASE_API_URL, method: .get, parameters: parameters).responseObject {
            (response: DataResponse<MovieSearchresultList>) in
            let success = (response.result.isSuccess && (response.value?.movieSearchResults?.count) ?? 0 > 0)
            var movieList = [MovieContent]()
            
            if success
            {
                for movieResult in response.value!.movieSearchResults!
                {
                    let movieContent = self.parseResultsToMovieContent(movieSearchresult: movieResult)
                    movieList.append(movieContent)
                }
            }
            
            completion(success, movieList)
        }
    }
}

struct MovieSearchresultList: Mappable
{
    var movieSearchResults: [MovieSearchResult]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map)
    {
        movieSearchResults <- map["Search"]
    }
}
