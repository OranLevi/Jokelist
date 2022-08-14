//
//  DetailsViewController.swift
//  JokeList
//
//  Created by Oran on 20/07/2022.
//

import UIKit

class DetailsViewController: UIViewController {

    var selectJoke: Welcome?

    @IBOutlet weak var setupLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }
    
    func setupLabels() {
        setupLabel.text = selectJoke?.setup
        deliveryLabel.text = selectJoke?.delivery
    }
}
