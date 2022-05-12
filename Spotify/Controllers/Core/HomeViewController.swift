//
//  HomeViewController.swift
//  Spotify
//
//  Created by Ahmed Amin on 09/05/2022.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSettingButton()
        getData()
       
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

//MARK: - Api Calling
extension HomeViewController {
    private func getData() {
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
