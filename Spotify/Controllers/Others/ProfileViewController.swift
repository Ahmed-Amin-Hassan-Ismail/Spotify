//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Ahmed Amin on 10/05/2022.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    //MARK: - Variables
    private var models = [String]()
    
    //MARK: - Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()

    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        fetchProfileData()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

//MARK: - Api Calling
extension ProfileViewController {
    private func fetchProfileData() {
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.failedToGetProfileData()
                }
            }
        }
    }
}

//MARK: - SetUP UI
extension ProfileViewController {
    private func updateUI(with model: UserProfile) {
        tableView.isHidden = false
        // configure tableview models
        models.append("Full Name: \(model.display_name)")
        models.append("Email Address: \(model.email)")
        models.append("User ID: \(model.id)")
        models.append("Plan: \(model.product)")
        createTableHeaderImage(with: model.images.first?.url)
        tableView.reloadData()
    }
    
    private func createTableHeaderImage(with string: String?) {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width / 1.5))
        let imageSize: CGFloat = headerView.height / 2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize / 2
        
        if let urlString = string, let url = URL(string: urlString) {
            imageView.sd_setImage(with: url, completed: nil)
        } else {
            imageView.image = UIImage(systemName: "person.crop.circle")
        }
        
        tableView.tableHeaderView = headerView
    }
    
    private func failedToGetProfileData() {
        let label = UILabel(frame: .zero)
        label.text = "failed to load profile"
        label.textColor = .secondaryLabel
        label.sizeToFit()
        view.addSubview(label)
        label.center = view.center
    }
}

//MARK: - TableView
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
}
