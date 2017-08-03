//
//  SpotifyAppleScriptAPI.swift
//  MiniSpotify
//
//  Created by Farbod Rafezy on 8/1/17.
//  Copyright © 2017 Farbod Rafezy. All rights reserved.
//

import Foundation

class SpotifyLocalAPI {

    static let baseAPIString = "tell application \"Spotify\" to "

    private static func retriveValue(from command: String) -> String {
        var result = ""
        let script = SpotifyLocalAPI.baseAPIString + command
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
            result = output.stringValue ?? "N/A"
        }
        return result
    }

    private static func perform(verb: String) {
        let script = SpotifyLocalAPI.baseAPIString + verb
        var error: NSDictionary?
        NSAppleScript(source: script)?.executeAndReturnError(&error)
    }

    static func getCurrentSongName() -> String {
        return retriveValue(from: "get name of current track as string")
    }

    static func getCurrentArtist() -> String {
        return retriveValue(from: "get artist of current track as string")
    }

    static func getPlayerState() -> String {
        return retriveValue(from: "get player state as string")
    }

    static func getCurrentAlbumArtURL() -> String {
        return retriveValue(from: "get artwork url of current track as string")
    }

    static func getCurrentSongDuration() -> String {
        return retriveValue(from: "get duration of current track as string")
    }

    static func getCurrentSongPosition() -> String {
        return retriveValue(from: "get player position as string")
    }

    static func setCurrentSongPosition(seconds: Double) {
        perform(verb: "set player position to \(seconds)")
    }

    static func getShufflingStatus() -> Bool {
        return Bool(retriveValue(from: "get shuffling as string"))!
    }

    static func getRepeatingStatus() -> Bool {
        return Bool(retriveValue(from: "get repeating as string"))!
    }

    static func enableShuffle() {
        perform(verb: "set shuffling to true")
    }

    static func disableShuffle() {
        perform(verb: "set shuffling to false")
    }

    static func enableLoop() {
        perform(verb: "set repeating to true")
    }

    static func disableLoop() {
        perform(verb: "set repeating to false")
    }

    static func play() {
        perform(verb: "play")
    }

    static func pause() {
        perform(verb: "pause")
    }

    static func nextTrack() {
        perform(verb: "next track")
    }

    static func previousTrack() {
        perform(verb: "previous track")
    }
}
