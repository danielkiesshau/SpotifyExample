//
//  Song.swift
//  SpotifyExample
//
//  Created by Daniel Kiesshau on 01/10/20.
//

import Foundation

class Song: Codable {
    var artist: String
    var title: String
    
    init (artist: String, title: String) {
        self.artist = artist
        self.title = title
    }
}
