//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by Ahmed Amin on 24/05/2022.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    static let identifier = "GenreCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "music.quarternote.3",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 50,
                                                                                 weight: UIImage.SymbolWeight.regular))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var label: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private lazy var colors: [UIColor] = [
        .systemPink,
        .systemBlue,
        .systemPurple,
        .systemOrange,
        .systemGreen,
        .systemRed,
        .systemYellow,
        .darkGray,
        .systemTeal
    ]
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 10, y: contentView.height/2, width: contentView.width-20, height: contentView.height/2)
        imageView.frame = CGRect(x: contentView.width/2, y: 10, width: contentView.width/2, height: contentView.height/2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        label.text = nil
    }
    
    func configure(with title: String) {
        label.text = title
        contentView.backgroundColor = colors.randomElement()
    }
    
}
