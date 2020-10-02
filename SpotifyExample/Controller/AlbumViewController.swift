//
//  AlbumViewController.swift
//  SpotifyExample
//
//  Created by Daniel Kiesshau on 01/10/20.
//

import UIKit
import UIImageColors

class AlbumViewController: UIViewController {

    var album:Album!
    var albumPrimaryColor: CGColor!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var titleLabel: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if UserService.shared.isFollowingAlbum(album: album){
            // set button text to "following" with a green color
            followButton.setTitle("Following", for: .normal)
            followButton.layer.borderColor = UIColor(red: 42.0 / 255.0, green: 183.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0).cgColor
        } else{
            followButton.setTitle("Follow", for: .normal)
            followButton.layer.borderColor = UIColor.white.cgColor
        }
        
        thumbnailImageView.image = UIImage(named: album.image)
        thumbnailImageView.image?.getColors() { colors in
            self.albumPrimaryColor = colors!.primary.withAlphaComponent( 0.8).cgColor
            self.updateBackgroundColor(color: self.albumPrimaryColor)
            
        }
        
        titleLabel.setTitle(album.name, for: .normal)
        followersLabel.text = "\(album.followers) Followers by \(album.artist)"
        
        
        shuffleButton.layer.cornerRadius = 10.0
        followButton.layer.cornerRadius = 5.0
        followButton.layer.borderWidth = 1.0
        followButton.layer.borderColor = UIColor.white.cgColor
        
        
    }
    
    @IBAction func shuffleTapped(_ sender: UIButton) {
        let randomIndex = Int(arc4random_uniform(UInt32(album.songs.count)))
        performSegue(withIdentifier: "SongSegue", sender: randomIndex)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let songViewController = segue.destination as? SongViewController,
           let randomSongIndex = sender as? Int {
            songViewController.selectedSongIndex = randomSongIndex
            songViewController.album = album
            songViewController.albumPrimaryColor = albumPrimaryColor
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func followButtonDidTapped(_ sender: Any) {
        // Check to see if the user is following the album
        if UserService.shared.isFollowingAlbum(album: album){
            // If our user is, then unfollow the album
            UserService.shared.unfollowAlbum(album: album)
            followButton.setTitle("Follow", for: .normal)
            followButton.layer.borderColor = UIColor.white.cgColor
        } else{
            // If our user is not, then follow the album
            UserService.shared.followAlbum(album: album)
            followButton.setTitle("Following", for: .normal)
            followButton.layer.borderColor = UIColor(red: 42.0 / 255.0, green: 183.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0).cgColor
        }
        
        followersLabel.text = "\(album.followers) followers - by \(album.artist)"
    }
    
    func updateBackgroundColor(color: CGColor) {
        let backgroundColor = view.backgroundColor!.cgColor
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.frame
        gradientLayer.colors = [backgroundColor, backgroundColor]
        gradientLayer.locations = [0.0, 0.4]
        
        let gradientChangeColor = CABasicAnimation(keyPath: "colors")
        gradientChangeColor.duration = 0.5
        gradientChangeColor.toValue = [color, backgroundColor]
        gradientChangeColor.isRemovedOnCompletion = false
        gradientChangeColor.fillMode = .forwards
        
        gradientLayer.add(gradientChangeColor, forKey: "ChangeColor")
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension AlbumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
        let song = album.songs[indexPath.row]
        cell.update(song: song)
        
        return cell
    }
    
    
}


extension AlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SongSegue", sender: indexPath.row)
    }
}
