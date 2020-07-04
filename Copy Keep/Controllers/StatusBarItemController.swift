//
//  StatusBarItemController.swift
//  Copy Keep
//
//  Created by Jay Mehta on 04/07/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Cocoa

class StatusBarItemController: NSObject {

    // MARK: - Properties

    private let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    private let menu = NSMenu()

    private let statusBarItemVM = StatusItemBarViewModel()

    // MARK : - Initialization

    override init() {
        super.init()

        statusBarItem.button?.image = NSImage(named: NSImage.Name(statusBarItemVM.statusBarImageName))

        setup()
    }
}

extension StatusBarItemController {
    // MARK: - Setup methods

    private func constructMenu() {
        menu.addItem(NSMenuItem.separator())

        menu.addItem(NSMenuItem(
            title: statusBarItemVM.clearMenuItemTitle,
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: statusBarItemVM.clearMenuItemKey
        ))

        menu.addItem(NSMenuItem(
            title: statusBarItemVM.exportMenuItemTitle,
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: statusBarItemVM.exportMenuItemKey
        ))

        menu.addItem(NSMenuItem.separator())

        menu.addItem(NSMenuItem(
            title: statusBarItemVM.quitMenuItemTitle,
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: statusBarItemVM.quitMenuItemKey
        ))


        statusBarItem.menu = menu
    }


    private func setup() {
        constructMenu()
    }
}
