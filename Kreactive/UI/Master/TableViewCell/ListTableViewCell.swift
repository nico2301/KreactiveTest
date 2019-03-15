//
//  ListTableViewCell.swift
//  Kreactive
//
//  Created by perotin nicolas on 13/03/2019.
//  Copyright © 2019 perotin nicolas. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    private var imageRequest: ImageRequest?
    
    var movie: Movie?{
        didSet{
            titleLabel?.text = movie?.title
            yearLabel?.text = movie?.year
            
            if let url = movie?.poster{
                imageRequest = ImageRequest()
                imageRequest?.load(url: url, withCompletion: { (result) in
                    DispatchQueue.main.async {
                        switch result{
                        case .success(let image): self.imgView.image = image
                        case .error( _): self.imgView.image = nil
                        }
                    }
                })
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
    }
}
