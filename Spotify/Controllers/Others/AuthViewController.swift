//
//  AuthViewController.swift
//  Spotify
//
//  Created by Ahmed Amin on 10/05/2022.
//

import UIKit
import WebKit


class AuthViewController: UIViewController {
    
    //MARK: - Variables
    public var completionHandler: ((Bool) -> Void)?
    
    //MARK: - Properties
    private let webView: WKWebView = {
        let preference = WKWebpagePreferences()
        preference.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = preference
        
        let webView = WKWebView(frame: .zero,
                                configuration: config)
        return webView
    }()

    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
     
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        guard let url = AuthManager.shared.signInURL else { return }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    
}

//MARK: - WKNavigationDelegate
extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        
        // Exchange the code for access token
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else { return }
        
        webView.isHidden = true
        
        AuthManager.shared.exchangeCodeForToken(code: code) { success in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                self.completionHandler?(success)
            }
        }
    }
    
}
