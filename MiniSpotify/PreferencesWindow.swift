//
//  PreferencesWindow.swift
//  MiniSpotify
//
//  Created by Farbod Rafezy on 8/11/17.
//  Copyright © 2017 Farbod Rafezy. All rights reserved.
//

import Cocoa

class PreferencesWindow: NSWindowController {

    override var windowNibName : String! {
        return "PreferencesWindow"
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
}
