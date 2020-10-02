//
//  AlbumCell.swift
//  SpotifyExample
//
//  Created by Daniel Kiesshau on 01/10/20.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    func update(album: Album) {
        thumbnailImageView.image = UIImage(named: album.image)
        titleLabel.text = album.name
        artistLabel.text = album.artist
    }
}
