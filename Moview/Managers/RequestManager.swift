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
    
    
    //MARK: - Check Internet Reachability
    
    class var isConnectedToInternet:Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
    
    
    private class func requestWith(url: String, method : HTTPMethod, parameters: Parameters? = nil) -> DataRequest
    {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = "application/json"
        
        return Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200..<401)
    }
    
    
    //MARK: - Search Movie By Title
    
    class func searchMovieFor(id: String, _ completion: @escaping (_ success: Bool, _ result: MovieSearchResult?) -> Void)
    {
        let parameters = [
            "apikey": API_KEY,
            "i": id
        ] as [String: AnyObject]
        
        requestWith(url: BASE_API_URL, method: .get, parameters: parameters).responseObject {
            (response: DataResponse<MovieSearchResult>) in
            let success = (response.result.isSuccess && response.value?.response == "True")
            completion(success, response.value)
        }
    }
    
    //MARK: - Search Movie By Title
    
    class func searchMoviesFor(name: String, _ completion: @escaping (_ success: Bool, _ result: MovieSearchresultList?) -> Void)
    {
        let parameters = [
            "apikey": API_KEY,
            "s": name
        ] as [String: AnyObject]
        
        requestWith(url: BASE_API_URL, method: .get, parameters: parameters).responseObject {
            (response: DataResponse<MovieSearchresultList>) in
            let success = (response.result.isSuccess && (response.value?.movieSearchResults?.count) ?? 0 > 0)
            completion(success, response.value)
        }
    }
    
    
    //MARK: - Download Movie Poster Image at URL
    
    class func getImageFromURL(path: String, _ completion: @escaping (_ success: Bool, _ image: UIImage?) -> Void)
    {
        requestWith(url: path, method: .get).response {
            response in
                let success = (response.data != nil && response.data != nil)
                var image: UIImage? = nil
            
                if success
                {
                    image = UIImage(data: response.data!)
                }
            
            completion(success, image)
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



//MARK: - Movie Search Result Object

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
