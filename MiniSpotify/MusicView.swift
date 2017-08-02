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
    @IBOutlet weak var previousTrackButton: NSButton!
    @IBOutlet weak var nextTrackButton: NSButton!
    @IBOutlet weak var shuffleButton: NSButton!
    @IBOutlet weak var loopButton: NSButton!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var songOptionsButton: NSButton!
    @IBOutlet weak var quitButton: NSButton!

    var isPlaying = false
    var currentAlbumArtURL = ""
    var albumArtIsLoading = true

    let playIcon = #imageLiteral(resourceName: "playImage")
    let pauseIcon = #imageLiteral(resourceName: "pauseImage")
    let nextTrackIcon = #imageLiteral(resourceName: "skipImage")
    let previousTrackIcon = #imageLiteral(resourceName: "skipBackImage")
    let shuffleIcon = #imageLiteral(resourceName: "shuffleImage")
    let loopIcon = #imageLiteral(resourceName: "loopImage")
    let saveIcon = #imageLiteral(resourceName: "plusImage")
    let songOptionsIcon = #imageLiteral(resourceName: "dropdownIcon")
    let quitIcon = #imageLiteral(resourceName: "quitImage")

    func setInitialTemplateIcons() {
        playIcon.isTemplate = true
        pauseIcon.isTemplate = true
        nextTrackIcon.isTemplate = true
        previousTrackIcon.isTemplate = true
        shuffleIcon.isTemplate = true
        loopIcon.isTemplate = true
        saveIcon.isTemplate = true
        songOptionsIcon.isTemplate = true
        quitIcon.isTemplate = true

        // play/pause icon is set in the setIsPlaying() function
        nextTrackButton.image = nextTrackIcon
        previousTrackButton.image = previousTrackIcon
        shuffleButton.image = shuffleIcon
        loopButton.image = loopIcon
        saveButton.image = saveIcon
        songOptionsButton.image = songOptionsIcon
        quitButton.image = quitIcon
    }

    func setSongName(name: String) {
        self.songName.stringValue = name
    }

    func setArtist(name: String) {
        self.artistName.stringValue = name
    }

    func setIsPlaying(state: String) {
        if state == "playing" {
            isPlaying = true
            playPauseButton.image = pauseIcon
        } else {
            isPlaying = false
            playPauseButton.image = playIcon
        }
    }

    func setAlbumArtwork(url: String) {
        if url != currentAlbumArtURL {
            let when = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: when) {
                if self.albumArtIsLoading {
                    self.albumCover.image = #imageLiteral(resourceName: "defaultAlbumArt")
                }
            }
            downloadAndDisplayAlbumArtwork(url: url)
            currentAlbumArtURL = url
        }
    }

    func downloadAndDisplayAlbumArtwork(url: String) {
        self.albumArtIsLoading = true
        let albumArtURL = URL(string: url)!
        let session = URLSession(configuration: .default)
        let downloadPicTask = session.dataTask(with: albumArtURL) { (data, response, error) in
            if let e = error {
                Swift.print("Error downloading picture: \(e)")
            } else {
                if (response as? HTTPURLResponse) != nil {
                    if let imageData = data {
                        let image = NSImage(data: imageData)
                        DispatchQueue.main.async {
                            self.albumCover.image = image
                            self.albumArtIsLoading = false
                        }
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
        playPauseButton.image = pauseIcon
        SpotifyLocalAPI.play()
    }

    func pause() {
        playPauseButton.image = playIcon
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
