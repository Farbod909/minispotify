//
//  MusicView.swift
//  MiniSpotify
//
//  Created by Farbod Rafezy on 7/31/17.
//  Copyright © 2017 Farbod Rafezy. All rights reserved.
//

import Cocoa

class MusicView: NSView {
    @IBOutlet weak var albumCover: NSImageView!
    @IBOutlet weak var songName: NSTextField!
    @IBOutlet weak var artistName: NSTextField!
    @IBOutlet weak var playPauseButton: NSButton!

    var isPlaying = false
    var currentAlbumArtURL = ""
    var currentAlbumArt = NSImage()

    func setSongName(name: String) {
        self.songName.stringValue = name
    }

    func setArtist(name: String) {
        self.artistName.stringValue = name
    }

    func setIsPlaying(state: String) {
        if state == "playing" {
            isPlaying = true
            playPauseButton.image = #imageLiteral(resourceName: "pauseImage")
        } else {
            isPlaying = false
            playPauseButton.image = #imageLiteral(resourceName: "playImage")
        }
    }

    func setAlbumArtwork(url: String) {
        if url != currentAlbumArtURL {
            downloadAndDisplayAlbumArtwork(url: url)
            currentAlbumArtURL = url
        }
    }

    func downloadAndDisplayAlbumArtwork(url: String) {
        let albumArtURL = URL(string: url)!
        let session = URLSession(configuration: .default)
        let downloadPicTask = session.dataTask(with: albumArtURL) { (data, response, error) in
            if let e = error {
                Swift.print("Error downloading picture: \(e)")
            } else {
                if let res = response as? HTTPURLResponse {
                    Swift.print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        let image = NSImage(data: imageData)
                        self.albumCover.image = image
                    } else {
                        Swift.print("Couldn't get image: Image is nil")
                    }
                } else {
                    Swift.print("Couldn't get response code")
                }
            }
        }
        downloadPicTask.resume()
    }

    func updateSongData() {
        setSongName(name: SpotifyLocalAPI.getCurrentSongName())
        setArtist(name: SpotifyLocalAPI.getCurrentArtist())
        setIsPlaying(state: SpotifyLocalAPI.getPlayerState())
        setAlbumArtwork(url: SpotifyLocalAPI.getCurrentAlbumArtURL())
    }

    func play() {
        playPauseButton.image = #imageLiteral(resourceName: "pauseImage")
        SpotifyLocalAPI.play()
    }

    func pause() {
        playPauseButton.image = #imageLiteral(resourceName: "playImage")
        SpotifyLocalAPI.pause()
    }

    @IBAction func playPauseToggle(_ sender: NSButton) {
        if isPlaying {
            pause()
        } else {
            play()
        }
        isPlaying = !isPlaying
    }

    @IBAction func nextTrackClicked(_ sender: NSButton) {
        SpotifyLocalAPI.nextTrack()
        updateSongData()
    }

    @IBAction func previousTrackClicked(_ sender: NSButton) {
        SpotifyLocalAPI.previousTrack()
        updateSongData()
    }

    @IBAction func quitApplication(_ sender: NSButton) {
        NSApplication.shared().terminate(self)
    }
}
