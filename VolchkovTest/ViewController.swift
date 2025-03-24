//
//  ViewController.swift
//  VolchkovTest
//
//  Created by Citylink on 25.01.2025.
//

import UIKit
import Stevia

class ViewController: UIViewController {
  
    var button1: UIButton!
    var button2: UIButton!
    var button3: UIButton!
    
    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        layoutT()
        fillCountries()
        askQuestion()
    }
    
    private func configure() {
        button1 = UIButton()
        button1.backgroundColor = .systemBlue
        button1.setImage(UIImage(named: "us"), for: .normal)
        button2 = UIButton()
        button2.backgroundColor = .systemBlue
        button2.setImage(UIImage(named: "us"), for: .normal)
        button3 = UIButton()
        button3.backgroundColor = .systemBlue
        button3.setImage(UIImage(named: "us"), for: .normal)
        [button1, button2, button3].forEach {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.addTarget(self, action: #selector(checkAnswer), for: .touchUpInside)
        }
        button1.tag = 0
        button2.tag = 1
        button3.tag = 2
    }
    
    private func layoutT() {
        
        view.subviews(button1, button2, button3)
        button1.height(100).width(200).Top == view.safeAreaLayoutGuide.Top + 200
        button2.Top == button1.Bottom + 16
        button2.height(100).width(200)
        button3.Top == button2.Bottom + 16
        button3.height(100).width(200)
        [button1, button2, button3].forEach {
            $0.centerHorizontally()
        }
    }
    private func fillCountries() {
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        correctAnswer = Int.random(in: 0..<3)
        title = countries[correctAnswer].uppercased()
    }
    
    @objc func checkAnswer(_ sender: UIButton) {
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
}

