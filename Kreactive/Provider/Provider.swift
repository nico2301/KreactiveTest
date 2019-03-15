//
//  MovieProvider.swift
//  Kreactive
//
//  Created by perotin nicolas on 13/03/2019.
//  Copyright © 2019 perotin nicolas. All rights reserved.
//

import Foundation

class Provider <Resource: ResourceType> {
    private lazy var resourceRequest = [String: ApiRequest<Resource>]()
    private lazy var searchCollectionRequest = [String: ApiRequest<ApiSearchCollection<Resource.Model>>]()
    private var urlComponents = Constant.ApiUrl.movieUrlComponents
    private var currentPage: Int?
    private var totalResults:Int?
    private var currentCount: Int?
    
    func getApiResource(_ url: String, completion: @escaping ((Result<Resource.Model>) -> Void)){
        let request = ApiRequest<Resource>()
        resourceRequest[url] = request
        resourceRequest[url]?.load(url: url, withCompletion: { (result) in
            self.resourceRequest[url] = nil
            completion(result)
        })
    }
    
    func getApiSearchCollection(search: String? = nil, page:Int? = 1, completion: @escaping ((Result<ApiSearchCollection<Resource.Model>>) -> Void)){
        if let search = search{
            currentPage = 0
            //remove old search queryItem
            let queryItems = urlComponents?.queryItems
            urlComponents?.queryItems = queryItems?.filter({ (queryItem) -> Bool in
                queryItem.name != Constant.ApiKey.search
            })
            let searchQueryItem = URLQueryItem(name: Constant.ApiKey.search, value: search)
            urlComponents?.queryItems?.append(searchQueryItem)
        }
        
        var url = urlComponents?.url?.absoluteString
        if let page = page{
            var urlComponents = self.urlComponents
            let pageQueryItem = URLQueryItem(name: Constant.ApiKey.page, value: "\(page)")
            urlComponents?.queryItems?.append(pageQueryItem)
            url = urlComponents?.url?.absoluteString
        }
        
        let request = ApiRequest<ApiSearchCollection<Resource.Model>>()
        searchCollectionRequest[url!] = request
        searchCollectionRequest[url!]?.load(url: url!, withCompletion: { [weak self] (result) in
            self?.searchCollectionRequest[url!] = nil
            switch result{
            case .success(let collection):
                self?.currentPage = (self?.currentPage ?? 0) + 1
                self?.totalResults = collection.totalResults
                self?.currentCount = (self?.currentCount ?? 0) + collection.items.count
                break
            case .error(_):
                break
            }
            completion(result)
        })
    }
    
    func canLoadMore() -> Bool{
        if let _ = currentPage, let currentCount = currentCount, let totalResults = totalResults, currentCount < totalResults {
            return true
        }
        return false
    }
    
    func loadMore(_ completion: @escaping ((Result<ApiSearchCollection<Resource.Model>>) -> Void)){
        if canLoadMore(){
            getApiSearchCollection(page: currentPage! + 1, completion: completion)
        }
        else{
            completion(Result.error(ApiError.NoDatasError))
        }
    }
}
