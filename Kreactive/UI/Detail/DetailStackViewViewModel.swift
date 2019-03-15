//
//  DetailStackViewViewModel.swift
//  Kreactive
//
//  Created by perotin nicolas on 14/03/2019.
//  Copyright © 2019 perotin nicolas. All rights reserved.
//

import UIKit

struct DetailStackViewViewModel {

    var title: String?
    var plot: String?
    var released: String?
    var genre: String?
    var runtime: String?
    var director: String?
    var actors: String?
    var language: String?
    var firstRating: String?
    var secondRating: String?
    
    init(movie: Movie){
        title = movie.title
        plot = movie.plot
        if let released = movie.released{
            self.released = "\(NSLocalizedString("Released", comment: "")) : \(released)"
        }
        if let genre = movie.genre{
            self.genre = "\(NSLocalizedString("Genre", comment: "")) : \(genre)"
        }
        if let runtime = movie.runtime{
            self.runtime = "\(NSLocalizedString("Runtime", comment: "")) : \(runtime)"
        }
        if let director = movie.director{
            self.director = "\(NSLocalizedString("Director", comment: "")) : \(director)"
        }
        if let actors = movie.actors{
            self.actors = "\(NSLocalizedString("Actors", comment: "")) : \(actors)"
        }
        if let language = movie.language{
            self.language = "\(NSLocalizedString("Languages", comment: "")) : \(language)"
        }
        
        //display only the first two ratings
        if (movie.ratings?.count ?? 0) > 0, let firstRating = movie.ratings?[0]{
            self.firstRating = "\(NSLocalizedString("Note", comment: "")) : \(firstRating.value ?? "") (\(firstRating.source ?? ""))"
        }
        if (movie.ratings?.count ?? 0) > 2, let secondRating = movie.ratings?[1]{
            self.secondRating = "\(NSLocalizedString("Note", comment: "")) : \(secondRating.value ?? "") (\(secondRating.source ?? ""))"
        }
    }
}
