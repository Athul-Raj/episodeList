//
//  ViewController.swift
//  sampleMyBliss
//
//  Created by Athul on 14/12/18.
//  Copyright © 2018 myBliss. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var imageViewUrl:URL!
    var episodeTitle: String = ""
    var episodeDescription: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = episodeTitle
        descriptionLabel.text = episodeDescription
        detailImageView.cacheImage(url: imageViewUrl)
    }
    @IBAction func closeViewButtonTapped(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }
}
