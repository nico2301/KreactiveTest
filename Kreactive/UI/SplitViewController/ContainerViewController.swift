//
//  ContainerViewController.swift
//  Kreactive
//
//  Created by perotin nicolas on 13/03/2019.
//  Copyright © 2019 perotin nicolas. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var rulesLabel: UILabel!{
        didSet{
            rulesLabel.text = NSLocalizedString("vote_rules", comment: "")
        }
    }
    @IBOutlet weak var startButton: UIButton!{
        didSet{
            startButton.setTitle(NSLocalizedString("start_button", comment: ""), for: .normal)
        }
    }
    
    @IBOutlet weak var startView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let splitViewController = children[0] as? UISplitViewController{
            splitViewController.preferredDisplayMode = .allVisible
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        performOverrideTraitCollection()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        performOverrideTraitCollection()
    }
    
    private func performOverrideTraitCollection(){
        let isPortrait = UIDevice.current.orientation.isPortrait
        //if portrait, always use .compact
        //if landscape, use regular for regular widths
        let isRegularSizeClass = (UIScreen.main.traitCollection.horizontalSizeClass == .regular)
        let sizeClass = isPortrait ? UIUserInterfaceSizeClass.compact : (isRegularSizeClass ? .regular : .compact)
        for child in children {
            setOverrideTraitCollection(UITraitCollection(horizontalSizeClass: sizeClass), forChild: child)
        }
    }
    
    @IBAction func startAction(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: {
            self.startView.alpha = 0
        }) { (finished) in
            self.startView.removeFromSuperview()
        }
    }
    
}
