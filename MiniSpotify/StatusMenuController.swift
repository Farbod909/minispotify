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

        musicView.songName.stringValue = SpotifyLocalAPI.getCurrentSongName()
        musicView.artistName.stringValue = SpotifyLocalAPI.getCurrentArtist()
        musicView.setIsPlayingState(state: SpotifyLocalAPI.getPlayerState())
    }

    
}
