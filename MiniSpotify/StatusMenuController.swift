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
        // set status bar icon
        let icon = #imageLiteral(resourceName: "spotifyIcon")
        icon.isTemplate = true // for dark mode
        statusItem.image = icon

        statusItem.menu = statusMenu
        musicMenuItem = statusMenu.item(withTitle: "Music")
        musicMenuItem.view = musicView

        // update song info upon start and every second thereafter
        update()
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        let rl = RunLoop.main
        rl.add(timer, forMode: RunLoopMode.commonModes)
    }

    func update() {
        musicView.updateSongData()
    }

}
