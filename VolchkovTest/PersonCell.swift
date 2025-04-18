import UIKit
import Stevia

class PersonCell: UICollectionViewCell {
    let imageView = UIImageView()
    let name = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Настройка внешнего вида ячейки
        backgroundColor = .white
        layer.cornerRadius = 8
        clipsToBounds = true
        
        // Конфигурация изображения
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        
        // Конфигурация метки
        name.font = UIFont(name: "MarkerFelt-Thin", size: 16) ?? UIFont.systemFont(ofSize: 16)
        name.textAlignment = .center
        name.numberOfLines = 2
        name.textColor = .darkGray
        
        subviews {
            imageView
            name
        }
        
        imageView.top(10).left(10).right(10).height(120)
        name.left(10).right(10).bottom(10).height(40)
        name.Top == imageView.Bottom + 4
    }
}
