//
//  RequestManager.swift
//  Moview
//
//  Created by Mehti Ozkan on 7.04.2021.
//


import Alamofire
import AlamofireObjectMapper
import ObjectMapper


class BaseService: NSObject
{
    static let BASE_API_URL = "http://www.omdbapi.com"
    static let API_KEY = "52a3219f"
    
    
    //MARK: - Check Internet Reachability
    
    public var isConnectedToInternet:Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
    
    public func requestWith(url: String, method : HTTPMethod, parameters: Parameters? = nil) -> DataRequest
    {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = "application/json"
        
        return Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200..<401)
    }
}





