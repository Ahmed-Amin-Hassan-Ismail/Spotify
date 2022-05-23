//
//  SearchViewController.swift
//  Spotify
//
//  Created by Ahmed Amin on 10/05/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: - Properties
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Songs, Artists, Albums"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        return searchController
    }()
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            self.configureCollectionView()
        }))

    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        self.setupUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

}

//MARK: - Configure Collection View
extension SearchViewController {
    
    private func configureCollectionView() -> NSCollectionLayoutSection {
        // Item
        let itemLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
        
        // Group
        let groupLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupLayoutSize,
            subitem: item,
            count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
                                            
        // Section
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func setupUI() {
        view.addSubview(collectionView)
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

//MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchResultsVC = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        print(query)
        // here will perform searching
        // Api Calling 
    }
}

//MARK: - Collection View
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: "Genre")
        return cell
    }
    
    
}
