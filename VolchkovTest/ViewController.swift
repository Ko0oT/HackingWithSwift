//
//  ViewController.swift
//  VolchkovTest
//
//  Created by Citylink on 25.01.2025.
//

import UIKit
import Stevia

final class ViewController: UIViewController {
    
    //MARK: - Propereries
    var pictures = [String]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        //Константа items будет массивом строк, содержащих имена файлов.
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
            
        }
        print(pictures)
    }
}


