//
//  DetailViewController.swift
//  VolchkovTest
//
//  Created by Serg on 18.03.2025.
//

import UIKit
import Stevia

class DetailViewController: UIViewController {
    
    var selectedImage: String?
    var imageView: UIImageView = UIImageView()
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
        //включает настройку скрытия навигационной панели по тапу 
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
        //отключает настройку скрытия навигационной панели по тапу
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        layout()
        // Do any additional setup after loading the view.
    }
    
    
    private func configure() {
        navigationItem.largeTitleDisplayMode = .never
        //убирает большой заголовок
        
        view.backgroundColor = .white
        
        title = selectedImage
        //добавляем заголовок
        
        navigationController?.navigationBar.prefersLargeTitles = true
        //делаем шрифт крупным
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        imageView.contentMode = .scaleAspectFill
        //растягивает изображение с сохранением соотношения сторон, чтобы заполнило весь вью
        
        imageView.clipsToBounds = true
        //обрезает по краям вью, чтобы лишнего не было за пределами экрана (без этой настройки при нажатии кнопки "Back" вылезают артефакты)
        
        navigationController?.hidesBarsOnTap = true
        //по тапу убирает навигационную панель или обратно возвращает.
    }
    
    private func layout() {
        view.subviews(imageView)
        imageView.Left == view.Left
        imageView.Right == view.Right
        imageView.Top == view.Top
        imageView.Bottom == view.Bottom
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
