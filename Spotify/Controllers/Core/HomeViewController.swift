//
//  HomeViewController.swift
//  Spotify
//
//  Created by Ahmed Amin on 09/05/2022.
//

import UIKit

enum BrowseSectionType {
    case newReleases
    case featuredPlaylists
    case recommendedTracks 
}

class HomeViewController: UIViewController {
    
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
                count: 3)

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
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    private func configureSpinnerView() {
        view.addSubview(spinner)
    }
}
//MARK: - Api Calling
extension HomeViewController {
    private func fetchData() {
        // New Releases
        // Featured Playlists, Recommended Tracks,
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
                
                APICaller.shared.getRecommendations(genres: seeds) { request in
                    switch request {
                    case .success(let model): break
                    case .failure(let error): break
                    }
                }
                
            case .failure(let error): break
            }
        }
    }
}

//MARK: - CollectionView
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.backgroundColor = .systemGreen
        case 1:
            cell.backgroundColor = .systemPink
        case 2:
            cell.backgroundColor = .systemBlue
        default:
            cell.backgroundColor = .clear
        }
        return cell
    }
}
