//
//  ViewController.swift
//  Winfox2
//
//  Created by Roman Efimov on 21.10.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var authorizationButton: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI(){
        registrationButton.layer.cornerRadius = 10
        authorizationButton.layer.cornerRadius = 10
    }


}

