//
//  RecommendedTrackCollectionViewCell.swift
//  Spotify
//
//  Created by Ahmed Amin on 14/05/2022.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    //MARK: - Properties
    private lazy var albumCoverImageView: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 4
        image.image = UIImage(systemName: "photo")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private lazy var creatorNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumCoverImageView.frame = CGRect(
            x: 5,
            y: 2,
            width: contentView.height - 4,
            height: contentView.height - 4
        )
        
        trackNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: 0,
            width: contentView.width - albumCoverImageView.right - 15,
            height: contentView.height / 2
        )
        
        creatorNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: contentView.height / 2,
            width: contentView.width - albumCoverImageView.right - 15,
            height: contentView.height / 2
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        albumCoverImageView.image = nil
        creatorNameLabel.text = nil
        
    }
}

//MARK: - Configure Cell
extension RecommendedTrackCollectionViewCell {
    func configure(with viewModel: RecommendedTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        creatorNameLabel.text = viewModel.artistName
    }
}
