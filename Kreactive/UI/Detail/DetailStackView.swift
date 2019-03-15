//
//  DetailStackView.swift
//  Kreactive
//
//  Created by perotin nicolas on 13/03/2019.
//  Copyright © 2019 perotin nicolas. All rights reserved.
//

import UIKit

class DetailStackView: UIStackView {

    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var ratingControl: RatingControl!
    
    var keypathsToDisplay = [\DetailStackViewViewModel.title,
                             \DetailStackViewViewModel.plot,
                             \DetailStackViewViewModel.released,
                             \DetailStackViewViewModel.genre,
                             \DetailStackViewViewModel.runtime,
                             \DetailStackViewViewModel.director,
                             \DetailStackViewViewModel.actors,
                             \DetailStackViewViewModel.language,
                             \DetailStackViewViewModel.firstRating,
                             \DetailStackViewViewModel.secondRating,]
    
    var viewModel: DetailStackViewViewModel?{
        didSet{
            ratingControl.isHidden = false
            for (index, label) in labels.enumerated(){
                DispatchQueue.main.async {
                    label.isHidden = true
                    if index < self.keypathsToDisplay.count{
                        let keypath = self.keypathsToDisplay[index]
                        if let text = self.viewModel?[keyPath: keypath]{
                            label.isHidden = false
                            label.text = text
                        }
                    }
                }
            }
        }
    }
    
    func resetView(){
        for subview in arrangedSubviews{
            subview.isHidden = true
        }
    }
}
