//
//  DetailViewController.swift
//  Kreactive
//
//  Created by perotin nicolas on 12/03/2019.
//  Copyright © 2019 perotin nicolas. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imgViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var stackView: DetailStackView!{
        didSet{
            stackView.ratingControl.didVote = didVote
        }
    }
    
    var imDBId: String?{
        didSet{
            if isViewLoaded{
                resetView()
            }
            //fetch movie detail
            let url = Constant.ApiUrl.detailUrl(for: imDBId!)
            provider.getApiResource(url, completion: { [weak self] (result) in
                switch result{
                case .success(let movie):
                    self?.movie = movie
                    self?.configureView()
                    break
                case .error (_):
                    break
                }
            })
        }
    }
    
    private var provider = Provider<Movie>()
    private var imageRequest = ImageRequest()
    private var movie: Movie?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetView()
        configureView()
    }
    
    private func resetView(){
        self.imgView?.image = nil
        stackView.resetView()
    }
    
    private func configureView() {
        DispatchQueue.main.async {
            if let movie = self.movie{
                self.stackView.ratingControl.rating = movie.vote ?? 0
                self.stackView?.viewModel = DetailStackViewViewModel(movie: movie)
                self.downloadImage(for: movie)
                let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapPoster))
                doubleTapRecognizer.numberOfTapsRequired = 2
                // add gesture recognizer to button
                self.imgView?.addGestureRecognizer(doubleTapRecognizer)
            }
        }
    }
    
    @objc func doubleTapPoster(doubleTapRecognizer: UITapGestureRecognizer) {
        if imgViewWidthConstraint.constant != imgView.superview!.bounds.width{
            imgViewWidthConstraint.constant = imgView.superview!.bounds.width
        }
        else{
            imgViewWidthConstraint.constant = imgView.superview!.bounds.width / 2
        }
    }
    
    func downloadImage(for movie: Movie){
        imageRequest.load(url: movie.poster, withCompletion: { [weak self] (result) in
            switch result{
            case .success(let image):
                DispatchQueue.main.async {
                    self?.imgView?.image = image
                }
                break
            case .error (_):
                break
            }
        })
    }
    
    private func didVote(rating: Int){
        movie?.vote = rating
    }
}

