//
//  Network.swift
//  PregBuddy Tweets
//
//  Created by Ashiq Sulaiman on 06/03/18.
//  Copyright © 2018 Ashiq Sulaiman. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


enum NetworkApi {
    case bearerToken
    case limit
    case baseURL
    
    var stringValue: String {
        switch self {
        case .baseURL: return "https://api.twitter.com/1.1/search/tweets.json?q="
        case .bearerToken: return "Bearer AAAAAAAAAAAAAAAAAAAAACqI2gAAAAAAxR0nG4lBcnKW%2BuXoyfg4r9j3ISg%3DeT8hqjYEneYWvhZtNRKo02djUcHBpYXCoa7AF1KVblo35uj233"
        case .limit: return "&count=100"
        }
    }
    
}

struct Network{
    
    public func searchTweet(completionHandler:@escaping (Data?) -> ()) {
        let urlString =  String(describing: NetworkApi.baseURL.stringValue+"pregnancy"+NetworkApi.limit.stringValue)
        let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var request = URLRequest(url: URL(string: url!)!)
        request.httpMethod = "GET"
        request.setValue(NetworkApi.bearerToken.stringValue, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).responseJSON { (response) in
            guard let data = response.data else {return}
            completionHandler(data)
        }
    }
    
}

