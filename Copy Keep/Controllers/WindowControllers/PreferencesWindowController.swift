//
//  PreferencesWindowController.swift
//  Copy Keep
//
//  Created by Jay Mehta on 05/07/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController {

    // MARK: - Lifecycle Methods

    static func instantiate() -> Self {
        let viewController = Storyboard.Main.instantiate(self)
        viewController.removeWindowBar()
        return viewController
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

    private func removeWindowBar() {
        self.window?.titleVisibility = .hidden
        self.window?.titlebarAppearsTransparent = true
        self.window?.styleMask.insert(.fullSizeContentView)
    }

}
