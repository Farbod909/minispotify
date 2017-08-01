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

    func setIsPlayingState(state: String) {
        if state == "playing" {
            isPlaying = true
            playPauseButton.image = #imageLiteral(resourceName: "pauseImage")
        } else {
            isPlaying = false
            playPauseButton.image = #imageLiteral(resourceName: "playImage")
        }
    }

    func play() {
        playPauseButton.image = #imageLiteral(resourceName: "pauseImage")
        SpotifyLocalAPI.play()
    }

    func pause() {
        playPauseButton.image = #imageLiteral(resourceName: "playImage")
        SpotifyLocalAPI.pause()
    }

    @IBAction func quitApplication(_ sender: NSButton) {
        NSApplication.shared().terminate(self)
    }
    @IBAction func playPauseToggle(_ sender: NSButton) {
        if isPlaying {
            pause()
        } else {
            play()
        }
        isPlaying = !isPlaying
    }
}
