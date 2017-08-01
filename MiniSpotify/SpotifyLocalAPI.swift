//
//  SpotifyAppleScriptAPI.swift
//  MiniSpotify
//
//  Created by Farbod Rafezy on 8/1/17.
//  Copyright © 2017 Farbod Rafezy. All rights reserved.
//

import Foundation

class SpotifyLocalAPI {

    static func getCurrentSongName() -> String {
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

    static func getCurrentArtist() -> String {
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

    static func getPlayerState() -> String {
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

    static func play() {
        let script =    "tell application \"Spotify\"\n" +
                            "play\n" +
                        "end tell"
        var error: NSDictionary?
        NSAppleScript(source: script)?.executeAndReturnError(&error)
    }

    static func pause() {
        let script =    "tell application \"Spotify\"\n" +
                            "pause\n" +
                        "end tell"
        var error: NSDictionary?
        NSAppleScript(source: script)?.executeAndReturnError(&error)
    }
}
