//
//  HomeViewController.swift
//  Spotify
//
//  Created by Ahmed Amin on 09/05/2022.
//

import UIKit

enum BrowseSectionType {
    case newReleases(viewModel: [NewReleasesCellViewModel])
    case featuredPlaylists(viewModel: [FeaturedPlaylistCellViewModel])
    case recommendedTracks(viewModel: [RecommendedTrackCellViewModel])
}

class HomeViewController: UIViewController {
    
    //MARK: - Variables
    private var sections = [BrowseSectionType]()
    
    //MARK: - Properties
    private lazy var collectionView = UICollectionView (
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            self?.createSectionLayout(section: sectionIndex)
        }))
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSettingButton()
        configureCollectionView()
        configureSpinnerView()
        fetchData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

//MARK: - Add Bar Item Button
extension HomeViewController {
    
    private func addSettingButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSetting))
    }
    
    @objc private func didTapSetting() {
        let vc = SettingsViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - SetupUI
extension HomeViewController {
    private func createSectionLayout(section: Int) -> NSCollectionLayoutSection? {
        switch section {
        case 0:
            // Item
            let itemLayoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Vertical group inside in horizontal group
            let verticalGroupLayoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(390))
            
            let horizontalGroupLayoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.9),
                heightDimension: .absolute(390))
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: verticalGroupLayoutSize,
                subitem: item,
                count: 3)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal (
                layoutSize: horizontalGroupLayoutSize,
                subitem: verticalGroup,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
            
        case 1:
            // Item
            let itemLayoutSize = NSCollectionLayoutSize(
                widthDimension: .absolute(200),
                heightDimension: .absolute(200))
            
            let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Vertical group inside in horizontal group
            let verticalGroupLayoutSize = NSCollectionLayoutSize(
                widthDimension: .absolute(200),
                heightDimension: .absolute(400))
            
            let horizontalGroupLayoutSize = NSCollectionLayoutSize(
                widthDimension: .absolute(200),
                heightDimension: .absolute(400))
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: verticalGroupLayoutSize,
                subitem: item,
                count: 2)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal (
                layoutSize: horizontalGroupLayoutSize,
                subitem: verticalGroup,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section
            
        case 2:
            // Item
            let itemLayoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Vertical group inside in horizontal group
            let verticalGroupLayoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(80))
            
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: verticalGroupLayoutSize,
                subitem: item,
                count: 1)
            
            
            // Section
            let section = NSCollectionLayoutSection(group: verticalGroup)
            return section
            
        default:
            // Item
            let itemLayoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Vertical group inside in horizontal group
            let verticalGroupLayoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(390))
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: verticalGroupLayoutSize,
                subitem: item,
                count: 3)
            
            // Section
            let section = NSCollectionLayoutSection(group: verticalGroup)
            return section
        }
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(NewReleaseCollectionViewCell.self,
                                forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self,
                                forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendedTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    private func configureSpinnerView() {
        view.addSubview(spinner)
    }
    
    private func configureModels(
        newAlbums: [Album],
        playlists: [Playlist],
        tracks: [AudioTrack]
    ) {
        sections.append(.newReleases(viewModel: newAlbums.compactMap({
            return NewReleasesCellViewModel(name: $0.name,
                                            artworkURL: URL(string: $0.images.first?.url ?? ""),
                                            numberOfTracks: $0.total_tracks,
                                            artistName: $0.artists.first?.name ?? "-")
        })))
        
        sections.append(.featuredPlaylists(viewModel: playlists.compactMap({
            return FeaturedPlaylistCellViewModel(name: $0.name,
                                                 artworkURL: URL(string: $0.images.first?.url ?? ""),
                                                 creatorName: $0.owner.display_name)
        })))
        
        sections.append(.recommendedTracks(viewModel: tracks.compactMap({
            return RecommendedTrackCellViewModel(name: $0.name,
                                                 artistName: $0.artists.first?.name ?? "-",
                                                 artworkURL: URL(string: $0.album?.images.first?.url ?? ""))
        })))
        
        collectionView.reloadData()
    }
}
//MARK: - Api Calling
extension HomeViewController {
    private func fetchData() {
        // Dispatch Group
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponse?
        var featuredPlaylist: FeaturedPlaylistsResponse?
        var recommendations: RecommendationsResponse?
        
        // New Releases
        APICaller.shared.getNewRelease { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Featured Playlists
        APICaller.shared.getFeaturePlaylist { [weak self] result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                featuredPlaylist = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Recommended Tracks
        APICaller.shared.getRecommendedGenres { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }

                APICaller.shared.getRecommendations(genres: seeds) { recommendedResult in
                    defer {
                        group.leave()
                    }

                    switch recommendedResult {
                    case .success(let model):
                        recommendations = model

                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylist?.playlists.items,
                  let tracks = recommendations?.tracks else {
                fatalError("Models are nil")
            }
            self?.configureModels(newAlbums: newAlbums,
                                  playlists: playlists,
                                  tracks: tracks)
        }
        
    }
}

//MARK: - CollectionView
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featuredPlaylists(let viewModels):
            return viewModels.count
        case .recommendedTracks(let viewModels):
            return viewModels.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
            
        case .newReleases(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleaseCollectionViewCell.identifier,
                for: indexPath) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModel[indexPath.row]
            cell.configure(with: viewModel)            
            return cell
            
        case .featuredPlaylists(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModel[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .recommendedTracks(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
                for: indexPath) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModel[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
    }
}
