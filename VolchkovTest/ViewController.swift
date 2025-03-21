//
//  ViewController.swift
//  VolchkovTest
//
//  Created by Citylink on 25.01.2025.
//

import UIKit
import Stevia

class ViewController: UIViewController {
  
    var firstButton: UIButton!
    var secondButton: UIButton!
    var thirdButton: UIButton!
    
    var countries = [String]()
    var score = 0
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        layoutT()
        fillCountries()
    }
    
    private func configure() {
        firstButton = UIButton()
        firstButton.backgroundColor = .systemBlue
        firstButton.setImage(UIImage(named: "us"), for: .normal)
        secondButton = UIButton()
        secondButton.backgroundColor = .systemBlue
        secondButton.setImage(UIImage(named: "us"), for: .normal)
        thirdButton = UIButton()
        thirdButton.backgroundColor = .systemBlue
        thirdButton.setImage(UIImage(named: "us"), for: .normal)
    }
    
    private func layoutT() {
        
        view.subviews(firstButton, secondButton, thirdButton)
        firstButton.height(100).width(200).Top == view.safeAreaLayoutGuide.Top + 200
        secondButton.Top == firstButton.Bottom + 16
        secondButton.height(100).width(200)
        thirdButton.Top == secondButton.Bottom + 16
        thirdButton.height(100).width(200)
        [firstButton, secondButton, thirdButton].forEach {
            $0.centerHorizontally()
        }
    }
    private func fillCountries() {
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    }
    
}


