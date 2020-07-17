//
//  ViewController.swift
//  SpotlightApp
//
//  Created by Ömer Faruk Öztürk on 1.12.2017.
//  Copyright © 2017 omerfarukozturk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionLabel.text = "Spotlight items loaded."
    }
    
    func setSelectedItem(data: [String : String]){
        thumbnailImage.image = UIImage(named: data["thumbnailImage"] ?? "")
        self.descriptionLabel.text = data["name"]
    }
    
}

