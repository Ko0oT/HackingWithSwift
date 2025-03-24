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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
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
    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }

        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // для iPad
//        На iPhone контроллеры вида активности автоматически занимают весь экран, но на iPad они отображаются как всплывающее окно, позволяющее пользователю видеть то, над чем он работал, ниже. Эта строка кода сообщает iOS о необходимости привязать контроллер вида активности к элементу кнопки правой панели (наша кнопка «Поделиться»), но это действует только на iPad — на iPhone это игнорируется.
        present(vc, animated: true)
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
