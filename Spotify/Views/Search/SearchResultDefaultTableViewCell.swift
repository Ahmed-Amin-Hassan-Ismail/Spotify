//
//  SearchResultDefaultTableViewCell.swift
//  Spotify
//
//  Created by Ahmed Amin on 25/05/2022.
//

import UIKit
import SDWebImage

class SearchResultDefaultTableViewCell: UITableViewCell {
    static let identifer = "SearchResultDefaultTableViewCell"
    private lazy var imageSize: CGFloat = contentView.height - 10
    
    //MARK: - Properties
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = imageSize / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = CGRect(
            x: 10,
            y: 0,
            width: imageSize,
            height: imageSize)
        
        titleLabel.frame = CGRect(
            x: iconImageView.right + 10,
            y: 0, width: contentView.width - iconImageView.right - 15,
            height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = nil
    }
    
}

//MARK: - Setup UI
extension SearchResultDefaultTableViewCell {
    
    private func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        self.accessoryType = .disclosureIndicator
    }
    
    func configure(with viewModel: SearchResultDefaultTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        iconImageView.sd_setImage(with: viewModel.imageURL)
    }
}
