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
        let script =    "tell application \"Spotify\"\n" +
                            "set currentTrackName to name of current track as string\n" +
                        "end tell\n" 
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
            songName = output.stringValue ?? "No Song Playing"
        }
        return songName
    }

    static func getCurrentArtist() -> String {
        var artist = ""
        let script =    "tell application \"Spotify\"\n" +
                            "set currentArtist to artist of current track as string\n" +
                        "end tell\n"
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
            artist = output.stringValue ?? "N/A"
        }
        return artist
    }

    static func getPlayerState() -> String {
        var state = ""
        let script =    "tell application \"Spotify\"\n" +
                            "set currentState to player state as string\n" +
                        "end tell\n"
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
            state = output.stringValue ?? "N/A"
        }
        return state
    }

    static func getCurrentAlbumArtURL() -> String {
        var url = ""
        let script =    "tell application \"Spotify\"\n" +
                            "set artUrl to artwork url of current track as string\n" +
                        "end tell"
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
            url = output.stringValue ?? "N/A"
        }
        return url
    }

    static func play() {
        let script = "tell application \"Spotify\" to play"
        var error: NSDictionary?
        NSAppleScript(source: script)?.executeAndReturnError(&error)
    }

    static func pause() {
        let script = "tell application \"Spotify\" to pause"
        var error: NSDictionary?
        NSAppleScript(source: script)?.executeAndReturnError(&error)
    }

    static func nextTrack() {
        let script = "tell application \"Spotify\" to next track"
        var error: NSDictionary?
        NSAppleScript(source: script)?.executeAndReturnError(&error)
    }

    static func previousTrack() {
        let script = "tell application \"Spotify\" to previous track"
        var error: NSDictionary?
        NSAppleScript(source: script)?.executeAndReturnError(&error)
    }
}
