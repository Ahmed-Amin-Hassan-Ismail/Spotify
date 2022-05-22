//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Ahmed Amin on 22/05/2022.
//

import UIKit

class AlbumViewController: UIViewController {

    private var album: Album
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground

     
    }
}


//MARK: - Api Calling
extension AlbumViewController {
    
}
