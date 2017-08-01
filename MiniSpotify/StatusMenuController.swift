//
//  StatusMenuController.swift
//  MiniSpotify
//
//  Created by Farbod Rafezy on 2/15/17.
//  Copyright © 2017 Farbod Rafezy. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var musicView: MusicView!
    var musicMenuItem: NSMenuItem!

    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        let icon = NSImage(named: "spotifyIcon")
        icon?.isTemplate = true // for dark mode
        statusItem.image = icon

        statusItem.menu = statusMenu

        musicMenuItem = statusMenu.item(withTitle: "Music")
        musicMenuItem.view = musicView

        musicView.songName.stringValue = getCurrentSongName()
        musicView.artistName.stringValue = getCurrentArtist()
        musicView.setIsPlayingState(state: getPlayerState())
    }

    func getCurrentSongName() -> String {
        var songName = ""
        let script =    "set track to getCurrentTrackName()\n" +
                        "on getCurrentTrackName()\n" +
                            "tell application \"Spotify\"\n" +
                                "set currentTrackName to name of current track as string\n" +
                                "return currentTrackName\n" +
                            "end tell\n" +
                        "end getCurrentTrackName"
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
            songName = output.stringValue ?? "No Song Playing"
        }
        return songName
    }

    func getCurrentArtist() -> String {
        var artist = ""
        let script =    "set artist to getCurrentArtist()\n" +
                        "on getCurrentArtist()\n" +
                            "tell application \"Spotify\"\n" +
                                "set currentArtist to artist of current track as string\n" +
                                "return currentArtist\n" +
                            "end tell\n" +
                        "end getCurrentArtist"
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
            artist = output.stringValue ?? "N/A"
        }
        return artist
    }

    func getPlayerState() -> String {
        var state = ""
        let script =    "set state to getCurrentState()\n" +
                        "on getCurrentState()\n" +
                            "tell application \"Spotify\"\n" +
                                "set currentState to player state as string\n" +
                                "return currentState\n" +
                            "end tell\n" +
                        "end getCurrentState"
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
            state = output.stringValue ?? "N/A"
        }
        return state

    }

}
