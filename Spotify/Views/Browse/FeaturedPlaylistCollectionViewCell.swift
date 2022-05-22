//
//  FeaturedPlaylistCollectionViewCell.swift
//  Spotify
//
//  Created by Ahmed Amin on 14/05/2022.
//

import UIKit
import SDWebImage

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    //MARK: - Properties
    private lazy var playlistCoverImageView: UIImageView = {
       let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 4
        image.image = UIImage(systemName: "photo")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var playlistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private lazy var creatorNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.height - 70
        playlistCoverImageView.frame = CGRect(
            x: (contentView.width - imageSize) / 2,
            y: 3,
            width: imageSize,
            height: imageSize
        )
        
        playlistNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height-60,
            width: contentView.width-6,
            height: 30
        )
        
        creatorNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height-30,
            width: contentView.width-6,
            height: 30
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        playlistCoverImageView.image = nil
        creatorNameLabel.text = nil
        
    }
}

//MARK: - Configure Cell
extension FeaturedPlaylistCollectionViewCell {
    func configure(with viewModel: FeaturedPlaylistCellViewModel) {
        playlistNameLabel.text = viewModel.name
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        creatorNameLabel.text = viewModel.creatorName
    }
}

