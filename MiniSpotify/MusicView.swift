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
    @IBOutlet weak var settingsButton: NSButton!
    @IBOutlet weak var songSlider: NSSlider!
    @IBOutlet weak var timeElapsedLabel: NSTextField!
    @IBOutlet weak var songDurationLabel: NSTextField!

    var preferencesWindow: PreferencesWindow!

    var isPlaying = false
    var currentAlbumArtURL = ""
    var albumArtIsLoading = true
    var currentSongDuration = "" //in milliseconds

    let playIcon = #imageLiteral(resourceName: "playImage")
    let pauseIcon = #imageLiteral(resourceName: "pauseImage")
    let nextTrackIcon = #imageLiteral(resourceName: "skipImage")
    let previousTrackIcon = #imageLiteral(resourceName: "skipBackImage")
    let shuffleIcon = #imageLiteral(resourceName: "shuffleImage")
    let loopIcon = #imageLiteral(resourceName: "loopImage")
    let saveIcon = #imageLiteral(resourceName: "plusImage")
    let songOptionsIcon = #imageLiteral(resourceName: "dropdownIcon")
    let quitIcon = #imageLiteral(resourceName: "quitImage")
    let settingsIcon = #imageLiteral(resourceName: "settingsImage")

    func initialize() {
        preferencesWindow = PreferencesWindow()

        playIcon.isTemplate = true
        pauseIcon.isTemplate = true
        nextTrackIcon.isTemplate = true
        previousTrackIcon.isTemplate = true
        shuffleIcon.isTemplate = true
        loopIcon.isTemplate = true
        saveIcon.isTemplate = true
        songOptionsIcon.isTemplate = true
        quitIcon.isTemplate = true
        settingsIcon.isTemplate = true

        // play/pause icon is set in the setIsPlaying() function
        nextTrackButton.image = nextTrackIcon
        previousTrackButton.image = previousTrackIcon
        shuffleButton.image = shuffleIcon
        loopButton.image = loopIcon
        saveButton.image = saveIcon
        songOptionsButton.image = songOptionsIcon
        quitButton.image = quitIcon
        settingsButton.image = settingsIcon

        songSlider.cell = SpotifySliderCell()
        songSlider.target = self
        songSlider.action = #selector(self.songSliderChanged)
    }

    // keep updateSongData and updatePlayPause seperate
    // so they can be called at different frequencies.
    func updateSongData() {
        setSongName(name: SpotifyLocalAPI.getCurrentSongName())
        setArtist(name: SpotifyLocalAPI.getCurrentArtist())
        setAlbumArtwork(url: SpotifyLocalAPI.getCurrentAlbumArtURL())
        setShuffle(enabled: SpotifyLocalAPI.getShufflingStatus())
        setLoop(enabled: SpotifyLocalAPI.getRepeatingStatus())
        setTimeElapsed(seconds: SpotifyLocalAPI.getCurrentSongPosition())
        currentSongDuration = SpotifyLocalAPI.getCurrentSongDuration()
        setSongDuration(milliseconds: currentSongDuration)
        setSongSliderValue(seconds: SpotifyLocalAPI.getCurrentSongPosition())
    }

    func updatePlayPause() {
        setIsPlaying(state: SpotifyLocalAPI.getPlayerState())
    }

    func updateAllItemsAfterSlightDelay() {
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.updatePlayPause()
            self.updateSongData()
        }
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

    func setShuffle(enabled: Bool) {
        if enabled {
            if shuffleButton.state == 0 {
                shuffleButton.setNextState()
            }
        } else {
            if shuffleButton.state == 1 {
                shuffleButton.setNextState()
            }
        }
    }

    func setLoop(enabled: Bool) {
        if enabled {
            if loopButton.state == 0 {
                loopButton.setNextState()
            }
        } else {
            if loopButton.state == 1 {
                loopButton.setNextState()
            }
        }
    }

    func setTimeElapsed(seconds: String) {
        if seconds == "missing value" {
            return timeElapsedLabel.stringValue = "--:--"
        }
        let secondsNum = Double(seconds)
        let minutes = Int(secondsNum! / 60)
        let remainingSeconds = Int(secondsNum! - Double(minutes * 60))
        var leadingChar = ""
        if remainingSeconds < 10 {
            leadingChar = "0"
        }
        timeElapsedLabel.stringValue = "\(minutes):\(leadingChar)\(remainingSeconds)"
    }

    func setSongDuration(milliseconds: String) {
        if milliseconds == "N/A" {
            return songDurationLabel.stringValue = "--:--"
        }
        let secondsNum = Int(Double(milliseconds)! / 1000)
        let minutes = secondsNum / 60
        let remainingSeconds = secondsNum - (minutes * 60)
        var leadingChar = ""
        if remainingSeconds < 10 {
            leadingChar = "0"
        }
        songDurationLabel.stringValue = "\(minutes):\(leadingChar)\(remainingSeconds)"
    }

    func setSongSliderValue(seconds: String) {
        if seconds == "missing value" {
            return songSlider.doubleValue = 0.0
        }
        let elapsedSecondsNum = Double(seconds)!
        let durationSecondsNum = Int(Double(currentSongDuration)! / 1000)

        songSlider.doubleValue = elapsedSecondsNum / Double(durationSecondsNum)
    }

    func setAlbumArtwork(url: String) {
        if url == "N/A" {
            return self.albumCover.image = #imageLiteral(resourceName: "defaultAlbumArt")
        }
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

    func play() {
        playPauseButton.image = pauseIcon
        SpotifyLocalAPI.play()
    }

    func pause() {
        playPauseButton.image = playIcon
        SpotifyLocalAPI.pause()
    }

    func songSliderChanged() {
        let durationSecondsNum = Double(currentSongDuration)! / 1000
        SpotifyLocalAPI.setCurrentSongPosition(seconds: songSlider.doubleValue * durationSecondsNum)
        // all items would have updated eventually but
        // this forces all items to be updated almost
        // immediately after
        updateAllItemsAfterSlightDelay()
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
        // all items would have updated eventually but
        // this forces all items to be updated almost
        // immediately after
        updateAllItemsAfterSlightDelay()
    }

    @IBAction func previousTrackClicked(_ sender: NSButton) {
        SpotifyLocalAPI.previousTrack()
        // all items would have updated eventually but
        // this forces all items to be updated almost
        // immediately after
        updateAllItemsAfterSlightDelay()
    }

    @IBAction func shuffleToggle(_ sender: NSButton) {
        if shuffleButton.state == 0 {
            // user clicked the shuffle button to disable it
            SpotifyLocalAPI.disableShuffle()
        } else {
            // user clicked the shuffle button to enable it
            SpotifyLocalAPI.enableShuffle()
        }
    }

    @IBAction func loopToggle(_ sender: NSButton) {
        if loopButton.state == 0 {
            // user clicked the loop button to disable it
            SpotifyLocalAPI.disableLoop()
        } else {
            // user clicked the loop button to enable it
            SpotifyLocalAPI.enableLoop()
        }
    }

    @IBAction func settingsClicked(_ sender: NSButton) {
        preferencesWindow.showWindow(nil)
    }

    @IBAction func quitApplication(_ sender: NSButton) {
        NSApplication.shared().terminate(self)
    }
}
