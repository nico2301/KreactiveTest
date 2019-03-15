//
//  SearchCollection.swift
//  Kreactive
//
//  Created by perotin nicolas on 12/03/2019.
//  Copyright © 2019 perotin nicolas. All rights reserved.
//

final class ApiSearchCollection <ModelType:Decodable>: Decodable {
    let items: [ModelType]
    let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case items = "Search"
        case totalResults
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let totalResultsString = try container.decodeIfPresent(String.self, forKey: .totalResults){
            totalResults = Int(totalResultsString)
        }
        else{
            totalResults = 0
        }
        items = try container.decode([ModelType].self, forKey: .items)
    }
}

extension ApiSearchCollection:ResourceType {
    typealias Model = ApiSearchCollection
}
