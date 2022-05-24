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
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let result = sections[indexPath.section].results[indexPath.row]
        switch result {
        case .artist(let model):
            cell.textLabel?.text = model.name
        case .album(let model):
            cell.textLabel?.text = model.name
        case .track(let model):
            cell.textLabel?.text = model.name
        case .playlist(let model):
            cell.textLabel?.text = model.name
        }
        return cell
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
