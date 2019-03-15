//
//  ListViewModel.swift
//  Kreactive
//
//  Created by perotin nicolas on 12/03/2019.
//  Copyright © 2019 perotin nicolas. All rights reserved.
//

import UIKit

class ListViewModel {
    private var isLoading = false
    private(set) lazy var items: [Movie] = [Movie]()
    private var provider: Provider<Movie>
    var datasDidLoad: (()->())?
    var datasDidAppend: ((_ fromIndex: Int)->())?
    var didFailLoading: ((Error)->())?
    
    init(provider: Provider<Movie>){
        self.provider = provider
    }
    
    func getItems(searchTerms:String? = nil){
        isLoading = true
        provider.getApiSearchCollection(search: searchTerms ?? "pirate", completion: { [weak self] (result) in
            switch result{
            case .success(let collection):
                DispatchQueue.main.async {
                self?.items = collection.items
                self?.datasDidLoad?()
                }
                break
            case .error(let error):
                self?.didFailLoading?(error)
                break
            }
            self?.isLoading = false
        })
    }
    
    func loadMoreItems(){
        if isLoading == false{
            isLoading = true
            provider.loadMore { [weak self] (result) in
                switch result{
                case .success(let collection):
                    DispatchQueue.main.async {
                    let count = self?.items.count
                    self?.items.append(contentsOf:collection.items)
                    self?.datasDidAppend?(count!)
                    }
                    break
                case .error(_):
                    break
                }
                self?.isLoading = false
            }
        }
    }
}
