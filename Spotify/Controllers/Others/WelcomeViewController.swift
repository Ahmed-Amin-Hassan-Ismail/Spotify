//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Ahmed Amin on 10/05/2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    //MARK: - Properties
    private var signInButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        return button
    }()

    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.signInButton.frame = CGRect(
            x: 20,
            y: view.height - 50 - view.safeAreaInsets.bottom,
            width: view.width - 40,
            height: 50
        )
    }
    
    @objc private func didTapSignIn() {
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completionHandler = { [weak self ] success in
            self?.handleSignIn(success: success)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        // log user or yell at them an error
        
        guard success else {
            let alert = UIAlertController(title: "Oops!",
                                          message: "something went wrong when signing in.",
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss",
                                       style: .cancel)
            alert.addAction(action)
            present(alert, animated: true)
            
            return
        }
        
        let mainTabBarViewController = TabBarViewController()
        mainTabBarViewController.modalPresentationStyle = .fullScreen
        present(mainTabBarViewController, animated: true)
    }

}
