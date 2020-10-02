//
//  SongCell.swift
//  SpotifyExample
//
//  Created by Daniel Kiesshau on 01/10/20.
//

import UIKit

class SongCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    func update(song: Song) {
        titleLabel.text = song.title
        artistLabel.text = song.artist
    }
}
