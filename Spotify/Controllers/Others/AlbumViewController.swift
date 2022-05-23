//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Ahmed Amin on 22/05/2022.
//

import UIKit

class AlbumViewController: UIViewController {
    
    //MARK: - Variables
    private var viewModels = [AlbumCollectionViewCellViewModel]()
    private var tracks = [AudioTrack]()
    private let album: Album
    
    //MARK: - Properties
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            self.configureCollectionView()
        }))
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        self.setupUI()
        self.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

//MARK: - Configure CollectionView
extension AlbumViewController {
    private func configureCollectionView() -> NSCollectionLayoutSection {
        // item
        let itemLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
        
        // Group
        let groupLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60.0))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupLayoutSize,
            subitem: item,
            count: 1)
        
        // Sectoion
        let section = NSCollectionLayoutSection(group: group)
        let boundaryLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.6))
        let boundarySupllementaryItems = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: boundaryLayoutSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        section.boundarySupplementaryItems = [boundarySupllementaryItems]
        return section
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.register(AlbumTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier)
        collectionView.register(PlaylistsHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistsHeaderCollectionReusableView.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

//MARK: - Api Calling
extension AlbumViewController {
    func fetchData() {
        APICaller.shared.getAlbumDetails(for: album) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.tracks = model.tracks.items
                    self?.viewModels = model.tracks.items.compactMap({
                        AlbumCollectionViewCellViewModel(
                            name: $0.name,
                            artistName: $0.artists.first?.name ?? "-"
                        )
                    })
                    self?.collectionView.reloadData()

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

//MARK: - CollectionView
extension AlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumTrackCollectionViewCell.identifier, for: indexPath) as? AlbumTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlaylistsHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? PlaylistsHeaderCollectionReusableView,
        kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerViewModel = PlaylistHeaderViewViewModel(
            name: album.name,
            ownerName: album.artists.first?.name,
            description: "Release Date: \(String.formattedDate(string: album.release_date))",
            artworkURL: URL(string: album.images.first?.url ?? "")
        )
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
    
}

//MARK: - PlaylistsHeaderCollectionReusableViewDelegate
extension AlbumViewController: PlaylistsHeaderCollectionReusableViewDelegate {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistsHeaderCollectionReusableView) {
        
    }
}
