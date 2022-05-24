//
//  SearchResultsSubtitleTableViewCell.swift
//  Spotify
//
//  Created by Ahmed Amin on 25/05/2022.
//



import UIKit
import SDWebImage

class SearchResultsSubtitleTableViewCell: UITableViewCell {
    static let identifer = "SearchResultsSubtitleTableViewCell"
    
    //MARK: - Properties
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
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
        let imageSize: CGFloat = contentView.height - 10
        let labelHeight = contentView.height / 2
        
        iconImageView.frame = CGRect(
            x: 10,
            y: 0,
            width: imageSize,
            height: imageSize)
        
        titleLabel.frame = CGRect(
            x: iconImageView.right + 10,
            y: 0, width: contentView.width - iconImageView.right - 15,
            height: labelHeight)
        
        subtitleLabel.frame = CGRect(
            x: iconImageView.right + 10,
            y: titleLabel.bottom,
            width: contentView.width - iconImageView.right - 15,
            height: labelHeight )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
}

//MARK: - Setup UI
extension SearchResultsSubtitleTableViewCell {
    
    private func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        self.accessoryType = .disclosureIndicator
    }
    
    func configure(with viewModel: SearchResultsSubtitleTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        iconImageView.sd_setImage(with: viewModel.imageURL)
    }
}

