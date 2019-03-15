//
//  NetworkRequest.swift
//  Kreactive
//
//  Created by perotin nicolas on 13/03/2019.
//  Copyright © 2019 perotin nicolas. All rights reserved.
//

import Foundation
import UIKit

//Protocols to wrap Sessions to easily test/mock
protocol URLSessionProtocol {
    func dataTask(withUrl: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol { func resume() }
extension URLSessionDataTask:URLSessionDataTaskProtocol{}

extension URLSession:URLSessionProtocol{
    func dataTask(withUrl: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: withUrl, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}

enum ApiError: Error{
    case DecodingError
    case NoDatasError
    case InvalidUrl
}

protocol NetworkRequest: class {
    associatedtype Model
    var session: URLSessionProtocol { get set }
    func load(url:String, withCompletion completion: @escaping (Result<Model>) -> Void)
    func decode(_ data: Data) -> Model?
}


extension NetworkRequest {
    fileprivate func load(_ url: URL, withCompletion completion: @escaping (Result<Model>) -> Void) {
        OperationQueue().addOperation {
            let task = self.session.dataTask(withUrl: url) { [weak self] (data, response, error) in
                if let error = error {
                    completion(Result.error(error))
                    return
                }
                guard let data = data else {
                    completion(.error(ApiError.NoDatasError))
                    return
                }
                if let model = self?.decode(data){
                    completion(.success(model))
                }
                else{
                    completion(.error(ApiError.DecodingError))
                }
            }
            task.resume()
        }
    }
}

class ImageRequest: NetworkRequest {
    var session: URLSessionProtocol
    
    init() {
        self.session = URLSession(configuration: .default)
    }
    
    func decode(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    func load(url:String, withCompletion completion: @escaping (Result<UIImage>) -> Void) {
        if let url = URL(string: url){
            load(url, withCompletion: completion)
        }
        else{
            completion(.error(ApiError.InvalidUrl))
        }
    }
    
}

protocol ResourceType{
    associatedtype Model:Decodable
}

class ApiRequest<Resource: ResourceType>: NetworkRequest {
    var session: URLSessionProtocol
    
    init() {
        self.session = URLSession(configuration: .default)
    }
    
    func decode(_ data: Data) -> Resource.Model? {
        do {
            let genericModel = try JSONDecoder().decode(Resource.Model.self, from: data)
            return genericModel
        } catch {
            return nil
        }
    }
    
    func load(url:String, withCompletion completion: @escaping (Result<Model>) -> Void) {
        if let url = URL(string: url){
            load(url, withCompletion: completion)
        }
        else{
            completion(.error(ApiError.InvalidUrl))
        }
    }
}
