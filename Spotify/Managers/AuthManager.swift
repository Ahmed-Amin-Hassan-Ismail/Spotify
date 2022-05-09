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
    
    var isSignIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExprirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
}
