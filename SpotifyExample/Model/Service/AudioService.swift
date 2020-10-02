//
//  AudioService.swift
//  SpotifyExample
//
//  Created by Daniel Kiesshau on 02/10/20.
//

import Foundation
import AVFoundation

protocol AudioServiceDelegate {
    func songIsPlaying(currentTime: Double, duration:Double)
}

class AudioService {
    static let shared = AudioService()
    let songs = ["song-0", "song-1", "song-2"]
    var audioPlayer: AVAudioPlayer!
    var delegate: AudioServiceDelegate?
    var timer: Timer?
    
    private init () {}
    
    func play(song: Song) {
        let randomgSong = songs.randomElement()!
        let songUrl = Bundle.main.url(forResource: randomgSong, withExtension: "mp3")!
        
        audioPlayer = try! AVAudioPlayer(contentsOf: songUrl)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        startTimer()
    }
    
    func pause() {
        audioPlayer.pause()
        stopTimer()
    }
    
    func resume() {
        audioPlayer.play()
        startTimer()
    }
    
    
    func play (atTime time: Double) {
        audioPlayer.currentTime = time
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (time) in
            self.delegate?.songIsPlaying(currentTime: self.audioPlayer.currentTime, duration: self.audioPlayer.duration)
        })
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
