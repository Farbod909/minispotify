//
//  StatusMenuController.swift
//  MiniSpotify
//
//  Created by Farbod Rafezy on 2/15/17.
//  Copyright © 2017 Farbod Rafezy. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject, NSMenuDelegate {
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var musicView: MusicView!
    var musicMenuItem: NSMenuItem!

    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

    var menuIsOpen = false
    
    override func awakeFromNib() {
        // set status bar icon
        let icon = #imageLiteral(resourceName: "spotifyIcon")
        icon.isTemplate = true
        statusItem.image = icon

        statusItem.menu = statusMenu
        musicMenuItem = statusMenu.item(withTitle: "Music")
        musicMenuItem.view = musicView

        statusMenu.delegate = self

        musicView.initialize()

        // Play/pause status is updated every tenth of a second, but
        // song data is updated every second. This is in order to
        // reduce CPU usage as much as possible.
        let playPauseTimer = Timer.scheduledTimer(
            timeInterval: 0.1, target: self,
            selector: #selector(self.updatePlayPause),
            userInfo: nil, repeats: true)
        let songDataTimer = Timer.scheduledTimer(
            timeInterval: 1.0, target: self,
            selector: #selector(self.updateSongData),
            userInfo: nil, repeats: true)
        let rl = RunLoop.main
        rl.add(playPauseTimer, forMode: RunLoopMode.commonModes)
        rl.add(songDataTimer, forMode: RunLoopMode.commonModes)
    }

    // keep updateSongData and updatePlayPause seperate
    // so they can be called at different frequencies.
    func updateSongData() {
        if menuIsOpen {
            musicView.updateSongData()
        }
    }

    func updatePlayPause() {
        if menuIsOpen {
            musicView.updatePlayPause()
        }
    }

    func menuWillOpen(_ menu: NSMenu) {
        menuIsOpen = true
        updatePlayPause()
        updateSongData()
    }

    func menuDidClose(_ menu: NSMenu) {
        menuIsOpen = false
    }
}
