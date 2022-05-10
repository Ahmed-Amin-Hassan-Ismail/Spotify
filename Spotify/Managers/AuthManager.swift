//
//  AuthManager.swift
//  Spotify
//
//  Created by Ahmed Amin on 10/05/2022.
//

import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    
    private init() { }
    
    struct Constants {
        static let clientID = "bb1eff014c184128b873e486652bb1e3"
        static let clientSecret = "ac7926f876844f2a8e1dc9e47d79459e"
        static let tokenApiURL = "https://accounts.spotify.com/api/token"
    }
    
    public var signInURL: URL? {
        let scopes = "user-read-private"
        let redirectURI = "https://github.com/Ahmed-Amin-Hassan-Ismail/Spotify"
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExprirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let tokenExprirationDate = tokenExprirationDate else {
            return false
        }
let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= tokenExprirationDate
    }
}

//MARK: - Methods
extension AuthManager {
    
    public func exchangeCodeForToken(code: String,
                                     completionHandler: @escaping ((Bool) -> Void) ) {
        // Get Token
        guard let url = URL(string: Constants.tokenApiURL) else { return }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "https://github.com/Ahmed-Amin-Hassan-Ismail/Spotify"),
        ]
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("FAILURE to get base64")
            completionHandler(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        request.httpBody = components.query?.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data , error == nil else {
                completionHandler(false)
                return
            }

            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completionHandler(true)
            } catch {
                print(error.localizedDescription)
                completionHandler(false)
            }
        }.resume()
        
    }
    
    public func refreshAccessToken() {
        
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.set(result.access_token, forKey: "access_token")
        UserDefaults.standard.set(result.refresh_token, forKey: "refresh_token")
        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}
