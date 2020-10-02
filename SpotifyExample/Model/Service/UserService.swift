//
//  UserService.swift
//  SpotifyExample
//
//  Created by Daniel Kiesshau on 01/10/20.
//

import Foundation

public class UserService {
    static let shared = UserService()
    private let currentUser = User()
    
    private init() {}
    
    func followAlbum(album: Album) -> Void {
        if !isFollowingAlbum(album: album) {
            currentUser.followingAlbums.append(album.name)
            album.followers += 1
        }
    }
    
    func unfollowAlbum(album: Album) -> Void {
        if let index = currentUser.followingAlbums.firstIndex(of: album.name) {
            currentUser.followingAlbums.remove(at: index)
            album.followers -= 1
        }
    }
    
    func isFollowingAlbum(album: Album) -> Bool {
        return currentUser.followingAlbums.contains(album.name)
    }
    
    
    func favoriteSong(song: Song) -> Void {
        if !isFavoritedSong(song: song) {
            currentUser.favoriteSongs.append(song.title)
        }
    }
    
    func unfavoriteSong(song: Song) -> Void {
        if let index = currentUser.favoriteSongs.firstIndex(of: song.title) {
            currentUser.favoriteSongs.remove(at: index)
        }
    }
    
    func isFavoritedSong(song: Song) -> Bool {
        return currentUser.favoriteSongs.contains(song.title)
    }
}
