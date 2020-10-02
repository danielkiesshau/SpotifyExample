//
//  SongViewController.swift
//  SpotifyExample
//
//  Created by Daniel Kiesshau on 02/10/20.
//

import UIKit

class SongViewController: UIViewController {

    var album: Album!
    var selectedSongIndex: Int!
    var albumPrimaryColor: CGColor!
    var userStartedSliding = false
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var trackSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundColor = view.backgroundColor!.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [backgroundColor, albumPrimaryColor!]
        gradientLayer.locations = [0.0, 0.4]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        thumbnailImageView.image = UIImage(named: "\(album.image)-lg")
        
        trackSlider.value = 0
        currentTimeLabel.text = "00:00"

        playButton.layer.cornerRadius = playButton.frame.size.height / 2.0
        updateFavoriteButton()
       
        AudioService.shared.delegate = self
        
        playSelectedSong()
    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        AudioService.shared.pause()
    }
    
    func playSelectedSong() {
        let selectedSong = album.songs[selectedSongIndex]
        
        titleLabel.text = selectedSong.title
        artistLabel.text = selectedSong.artist
        
        AudioService.shared.play(song: selectedSong)
    }
    
    func updateFavoriteButton() {
        if UserService.shared.isFavoritedSong(song: album.songs[selectedSongIndex]) {
            favoriteButton.setImage(UIImage(named: "heart-filled"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "heart"), for: .normal)
        }
        
    }
    
    
    @IBAction func favoriteTapped(_ sender: UIButton) {
        let selectedSong = album.songs[selectedSongIndex]
        if UserService.shared.isFavoritedSong(song: selectedSong) {
            UserService.shared.unfavoriteSong(song: selectedSong)
            favoriteButton.setImage(UIImage(named: "heart"), for: .normal)
        } else {
            UserService.shared.favoriteSong(song: selectedSong)
            favoriteButton.setImage(UIImage(named: "heart-filled"), for: .normal)
        }
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        selectedSongIndex = max(0, selectedSongIndex - 1)
        updateFavoriteButton()
        playSelectedSong()
    }
    
    @IBAction func playTapped(_ sender: UIButton) {
        let TAG_PLAY = 1;
        let TAG_PAUSE = 0;
        if sender.tag == TAG_PAUSE {
            AudioService.shared.pause()
            sender.setImage(UIImage(named: "play"), for: .normal)
            sender.tag = TAG_PLAY
        } else if sender.tag == TAG_PLAY {
            AudioService.shared.resume()
            sender.setImage(UIImage(named: "pause"), for: .normal)
            sender.tag = TAG_PAUSE
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        selectedSongIndex = (selectedSongIndex + 1) % album.songs.count
        updateFavoriteButton()
        playSelectedSong()
    }
    
    @IBAction func sliderValueDidChange(_ sender: UISlider) {
        
        if sender.isContinuous {
            userStartedSliding = true
            sender.isContinuous = false
        } else {
            AudioService.shared.play(atTime: Double(sender.value))
            sender.isContinuous = true
            userStartedSliding = false
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SongViewController: AudioServiceDelegate{
    func songIsPlaying(currentTime: Double, duration: Double) {
        trackSlider.maximumValue = Float(duration)
        
        if !userStartedSliding{
            trackSlider.value = Float(currentTime)
        }
        
        // Update current time + duration labels (i.e. 12:01)
        currentTimeLabel.text = stringFromTime(time: currentTime)
        durationLabel.text = stringFromTime(time: duration)
    }
    
    func stringFromTime(time: Double) -> String{
        let seconds = Int(time) % 60
        let minutes = (Int(time) / 60) % 60
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}
