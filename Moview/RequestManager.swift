//
//  RequestManager.swift
//  Moview
//
//  Created by Mehti Ozkan on 7.04.2021.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper


class RequestManager: NSObject
{
    private static let BASE_API_URL = "http://www.omdbapi.com"
    private static let API_KEY = "52a3219f"
    
    
    private class func requestWith(url: String, method : HTTPMethod, parameters: Parameters? = nil) -> DataRequest
    {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = "application/json"
        
        return Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200..<401)
    }
    
    
    //MARK: - Search Moview By Title
    
    class func searchMovieFor(name: String, _ completion: @escaping (_ success: Bool, _ result: MovieSearchResult?) -> Void)
    {
        let parameters = [
            "apikey": API_KEY,
            "t": name
        ] as [String: AnyObject]
        
        requestWith(url: BASE_API_URL, method: .get, parameters: parameters).responseObject {
            (response: DataResponse<MovieSearchResult>) in
                let success = (response.result.isSuccess && response.value != nil)
            completion(success, response.value)
        }
    }
}


//MARK: - Movie Search Result Object

struct MovieSearchResult: Mappable
{
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
