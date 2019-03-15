//
//  Constants.swift
//  Kreactive
//
//  Created by perotin nicolas on 13/03/2019.
//  Copyright © 2019 perotin nicolas. All rights reserved.
//

import Foundation

struct Constant {
    struct ApiUrl {
        private static let baseUrl = "http://www.omdbapi.com"
        private static let apiKeyQueryItem = URLQueryItem(name: "apikey", value: "5860b71e")
        private static let movieQueryItem = URLQueryItem(name: "type", value: "movie")
        static var baseUrlComponents: URLComponents?{
            var urlComponents = URLComponents(string: baseUrl)
            urlComponents?.queryItems = [apiKeyQueryItem]
            return urlComponents
        }
        static var movieUrlComponents: URLComponents?{
            var urlComponents = baseUrlComponents
            urlComponents?.queryItems?.append(movieQueryItem)
            return urlComponents
        }
        static func detailUrl(for imDBId: String)-> String{
            var urlComponents = baseUrlComponents
            urlComponents?.queryItems?.append(URLQueryItem(name: "i", value: imDBId))
            return (urlComponents?.url?.absoluteString)!
        }
    }
    
    struct ApiKey{
        static let search = "s"
        static let page = "page"
    }
    struct CellIdentifier{
        static let ListTableViewCell = "ListTableViewCell"
    }
}
