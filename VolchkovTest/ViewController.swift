//
//  ViewController.swift
//  VolchkovTest
//
//  Created by Citylink on 25.01.2025.
//

import UIKit
import Stevia

final class ViewController: UITableViewController {
    
    //MARK: - Propereries
    var pictures = [String]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Storm Viewer"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.accessoryType = .disclosureIndicator
        //добавляет шеврон справа
        
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70 // Высота ячеек
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Go to \(pictures[indexPath.row])")
        
        let dvc = DetailViewController()
        dvc.selectedImage = pictures[indexPath.row]
        navigationController?.pushViewController(dvc, animated: true)
        
    }
}


