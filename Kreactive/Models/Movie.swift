//
//  Movie.swift
//  Kreactive
//
//  Created by perotin nicolas on 12/03/2019.
//  Copyright © 2019 perotin nicolas. All rights reserved.
//

class RatingSource: Decodable{
    var source: String?
    var value: String?
    
    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}

class Movie: Decodable {
    var title: String?
    var year: String?
    var imdbID: String?
    var poster: String
    var genre: String?
    var released: String?
    var runtime: String?
    var director: String?
    var actors: String?
    var plot: String?
    var language: String?
    var ratings: [RatingSource]?
    var vote:Int?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case poster = "Poster"
        case genre = "Genre"
        case released = "Released"
        case runtime = "Runtime"
        case director = "Director"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case ratings = "Ratings"
    }
}

extension Movie:ResourceType{
    typealias Model = Movie
}
