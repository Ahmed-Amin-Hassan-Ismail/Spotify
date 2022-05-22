//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by Ahmed Amin on 22/05/2022.
//

import UIKit

class PlaylistViewController: UIViewController {

    private var playlist: Playlist
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground

     
    }

}

//MARK: - Api Calling
extension PlaylistViewController {
    
}
