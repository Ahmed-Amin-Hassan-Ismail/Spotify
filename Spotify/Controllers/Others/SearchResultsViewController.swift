//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by Ahmed Amin on 23/05/2022.
//

import UIKit

struct SectionResult {
    let title: String
    let results: [SearchResult]
}

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewController(_ controller: SearchResultsViewController, didTap result: SearchResult)
}

class SearchResultsViewController: UIViewController {
    
    //MARK: - Variables
    private var sections = [SectionResult]()
    weak var delegate: SearchResultsViewControllerDelegate?
    
    //MARK: - Properties
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifer)
        table.register(SearchResultsSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultsSubtitleTableViewCell.identifer)
        table.isHidden = true
        return table
    }()
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        self.setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with results: [SearchResult]) {
        // artists
        let artists = results.filter {
            switch $0 {
            case .artist:
                return true
            default:
                return false
            }
        }
        
        // Album
        let albums = results.filter {
            switch $0 {
            case .album:
                return true
            default:
                return false
            }
        }
        
        // Track
        let tracks = results.filter {
            switch $0 {
            case .track:
                return true
            default:
                return false
            }
        }
        
        //Playlists
        let playlists = results.filter {
            switch $0 {
            case .playlist:
                return true
            default:
                return false
            }
        }
        
        self.sections = [SectionResult(title: "Songs", results: tracks),
                         SectionResult(title: "Artists", results: artists),
                         SectionResult(title: "Playlists", results: playlists),
                         SectionResult(title: "Albums", results: albums)]
        tableView.isHidden = results.isEmpty
        tableView.reloadData()
    }
    
}

//MARK: - Setup UI
extension SearchResultsViewController {
    private func setupUI() {
        view.addSubview(tableView)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//MARK: - TableView
extension SearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsSubtitleTableViewCell.identifer, for: indexPath) as? SearchResultsSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let result = sections[indexPath.section].results[indexPath.row]
        switch result {
            
        case .artist(let artist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifer, for: indexPath) as? SearchResultDefaultTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultDefaultTableViewCellViewModel(title: artist.name,
                                                                      imageURL: URL(string: artist.images?.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
            
        case .album(let album):
            let viewModel = SearchResultsSubtitleTableViewCellViewModel(title: album.name,
                                                                        subtitle: album.artists.first?.name ?? "",
                                                                        imageURL: URL(string: album.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
            
        case .track(let track):
            let viewModel = SearchResultsSubtitleTableViewCellViewModel(title: track.name,
                                                                        subtitle: track.artists.first?.name ?? "",
                                                                        imageURL: URL(string: track.album?.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
                        
        case .playlist(let playlist):
            let viewModel = SearchResultsSubtitleTableViewCellViewModel(title: playlist.name,
                                                                        subtitle: playlist.owner.display_name,
                                                                        imageURL: URL(string: playlist.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.searchResultsViewController(self, didTap: result)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}
