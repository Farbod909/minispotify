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

        // update song info upon start and every 0.1 seconds thereafter
        musicView.updateSongData()
        let everyTenthOfASecond = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updatePlayPause), userInfo: nil, repeats: true)
        let everySecond = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        let rl = RunLoop.main
        rl.add(everyTenthOfASecond, forMode: RunLoopMode.commonModes)
        rl.add(everySecond, forMode: RunLoopMode.commonModes)
    }

    func update() {
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
    }

    func menuDidClose(_ menu: NSMenu) {
        menuIsOpen = false
    }
}
