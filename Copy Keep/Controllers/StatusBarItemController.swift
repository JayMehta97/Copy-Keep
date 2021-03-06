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
    private let pasteboard = NSPasteboard.general

    private var preferencesWindowController: PreferencesWindowController?

    private let statusBarItemVM = StatusItemBarViewModel()

    // MARK: - Initialization

    override init() {
        super.init()

        statusBarItem.button?.image = NSImage(named: NSImage.Name(statusBarItemVM.statusBarImageName))

        // Setup
        self.setup()
    }
}

extension StatusBarItemController {
    // MARK: - Setup methods

    private func constructMenu() {
        addSavedCopyItemsToMenu()
        addOptionItemsToMenu()

        statusBarItem.menu = menu
    }

    func watchPasteboard(copied: @escaping (_ copiedString: String) -> Void) {
        var changeCount = pasteboard.changeCount
        Timer.scheduledTimer(withTimeInterval: statusBarItemVM.watchBoardCheckTimeFrequency, repeats: true) { _ in
            if let copiedString = self.pasteboard.string(forType: .string) {
                if self.pasteboard.changeCount != changeCount {
                    copied(copiedString)
                    changeCount = self.pasteboard.changeCount
                }
            }
        }
    }

    private func setup() {
        constructMenu()

        // Add StatusBarController to CoreDataManager's delegate list to receive database changes events
        CoreDataManager.shared.addDelegate(coreDataManagerDelegate: self, forEntity: .copyItem)

        watchPasteboard { copiedContent in
            DispatchQueue.main.async {
                self.statusBarItemVM.addCopyItem(forCopiedContent: copiedContent)
            }
        }
    }
}

extension StatusBarItemController {
    // MARK: - Static menu items

    func createClearMenuItem() -> NSMenuItem {
        let clearMenuItem = NSMenuItem(
            title: statusBarItemVM.clearMenuItemTitle,
            action: #selector(StatusBarItemController.clearAllCopyItemsClicked),
            keyEquivalent: statusBarItemVM.clearMenuItemKey
        )

        clearMenuItem.target = self
        return clearMenuItem
    }

    func createExportMenuItem() -> NSMenuItem {
        let exportMenuItem = NSMenuItem(
            title: statusBarItemVM.exportMenuItemTitle,
            action: #selector(StatusBarItemController.exportMenuItemClicked),
            keyEquivalent: statusBarItemVM.exportMenuItemKey
        )

        exportMenuItem.target = self
        return exportMenuItem
    }

    func createPreferencesMenuItem() -> NSMenuItem {
        let preferencesMenuItem = NSMenuItem(
            title: statusBarItemVM.preferencesMenuItemTitle,
            action: #selector(StatusBarItemController.openPreferences(_:)),
            keyEquivalent: statusBarItemVM.preferencesMenuItemKey
        )

        preferencesMenuItem.target = self
        return preferencesMenuItem
    }

    func createQuitMenuItem() -> NSMenuItem {
        let quitMenuItem = NSMenuItem(
            title: statusBarItemVM.quitMenuItemTitle,
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: statusBarItemVM.quitMenuItemKey
        )

        return quitMenuItem
    }
}

extension StatusBarItemController: CoreDataManagerDelegate {
    // MARK: - CoreDataManagerDelegate Methods

    func newItemInserted(atIndex indexPath: IndexPath) {
        guard let copyItem = statusBarItemVM.getCopyItems()?.first else {
            return
        }

        addCopyItemToMenu(copyItem: copyItem)
        changeShortcutKeysForMenuItems()
    }

    func itemDeleted(atIndex index: IndexPath) {
        menu.items.remove(at: index.item)
        changeShortcutKeysForMenuItems()
    }
}

extension StatusBarItemController {
    // MARK: - Menu Items related methods

    private func addCopyItemToMenu(copyItem: CopyItem) {
        let menuItem = NSMenuItem(
            title: copyItem.title,
            action: #selector(StatusBarItemController.copyMenuItemContentToPasteBoard(_:)),
            keyEquivalent: ""
        )
        menuItem.target = self
        menuItem.toolTip = copyItem.content
        menu.insertItem(menuItem, at: 0)
    }

    private func addSavedCopyItemsToMenu() {
        // Copy Items from coreDataManager are already correctly sorted in descending order but we reverse them so that we can add all elements at zero position in NSMenu.
        guard let copyItems = statusBarItemVM.getCopyItems()?.reversed() else {
            return
        }

        for copyItem in copyItems {
            addCopyItemToMenu(copyItem: copyItem)
        }

        changeShortcutKeysForMenuItems()
    }

    private func addOptionItemsToMenu() {
        menu.addItem(NSMenuItem.separator())
        menu.addItem(createClearMenuItem())
        menu.addItem(createExportMenuItem())

        menu.addItem(NSMenuItem.separator())
        menu.addItem(createPreferencesMenuItem())

        menu.addItem(NSMenuItem.separator())
        menu.addItem(createQuitMenuItem())
    }

    private func changeShortcutKeysForMenuItems() {
        for (counter, menuItem) in menu.items.enumerated() {
            if counter == statusBarItemVM.maximumMenuItemsWithKeys || menuItem.isSeparatorItem {
                menuItem.keyEquivalent = ""
                break
            }

            menuItem.keyEquivalent = counter.description
        }
    }
}

extension StatusBarItemController {
    // MARK: - User Interactions methods

    @objc func clearAllCopyItemsClicked() {
        statusBarItemVM.clearAllCopyItems()

        AnalyticsManager.shared.track(eventName: Constants.Analytics.keepsCleared)
    }

    @objc func copyMenuItemContentToPasteBoard(_ sender: Any?) {
        guard let menuItem = sender as? NSMenuItem else {
            return
        }

        pasteboard.clearContents()

        // We copy content of tooltip to clipboard as it has the full content of that CopyItem.
        pasteboard.setString(menuItem.toolTip ?? "", forType: .string)

        AnalyticsManager.shared.track(eventName: Constants.Analytics.keepCopied)
    }

    @objc func openPreferences(_ sender: Any?) {
        if preferencesWindowController == nil {
            preferencesWindowController = PreferencesWindowController.instantiate()
        }
        preferencesWindowController?.showWindow(self)

        NSApp.activate(ignoringOtherApps: true)
    }

    @objc func exportMenuItemClicked() {
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = Constants.File.copyKeepItemsJson
        savePanel.begin { result in
            if let url = savePanel.url, result == .OK {
                self.statusBarItemVM.exportCopyItems(toFileUrl: url)
            }
        }

        AnalyticsManager.shared.track(eventName: Constants.Analytics.keepsExported)
    }
}
