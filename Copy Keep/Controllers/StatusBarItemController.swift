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

    private let statusBarItemVM = StatusItemBarViewModel()
    private var coreDataManager: CoreDataManager?

    // MARK : - Initialization

    override init() {
        super.init()

        statusBarItem.button?.image = NSImage(named: NSImage.Name(statusBarItemVM.statusBarImageName))

        // Setup Core Data Manager
        coreDataManager = CoreDataManager(modelName: statusBarItemVM.coreDataModelName, completion: {
            self.setup()
        })
    }
}

extension StatusBarItemController {
    // MARK: - Setup methods

    private func constructMenu() {

        addSavedCopyItemsToMenu()

        menu.addItem(NSMenuItem.separator())

        let clearMenuItem = NSMenuItem(
            title: statusBarItemVM.clearMenuItemTitle,
            action: #selector(StatusBarItemController.clearAllCopyItems(_:)),
            keyEquivalent: statusBarItemVM.clearMenuItemKey
        )
        clearMenuItem.target = self

        menu.addItem(clearMenuItem)

        menu.addItem(NSMenuItem(
            title: statusBarItemVM.exportMenuItemTitle,
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: statusBarItemVM.exportMenuItemKey
        ))

        menu.addItem(NSMenuItem.separator())

        let preferencesMenuItem = NSMenuItem(
            title: statusBarItemVM.preferencesMenuItemTitle,
            action: #selector(StatusBarItemController.openPreferences(_:)),
            keyEquivalent: statusBarItemVM.preferencesMenuItemKey
        )
        preferencesMenuItem.target = self

        menu.addItem(preferencesMenuItem)

        menu.addItem(NSMenuItem.separator())

        menu.addItem(NSMenuItem(
            title: statusBarItemVM.quitMenuItemTitle,
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: statusBarItemVM.quitMenuItemKey
        ))


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

        coreDataManager?.delegate = self

        watchPasteboard { copiedContent in
            DispatchQueue.main.async {
                if self.shouldCopyItemBeSaved(forCopiedContent: copiedContent) {
                    self.addCopyItem(forCopiedContent: copiedContent)
                }
            }
        }
    }
}

extension StatusBarItemController {
    // MARK: - Helper methods

    private func shouldCopyItemBeSaved(forCopiedContent copiedContent: String) -> Bool {
        guard let copyItems = coreDataManager?.getCopyItems() else {
            return true
        }

        for (index, copyItem) in zip(copyItems.indices, copyItems) {
            if index >= statusBarItemVM.thresholdToForDuplicateCopy {
                break
            }

            if copyItem.content == copiedContent {
                return false
            }
        }
        return true
    }

    private func addCopyItem(forCopiedContent copiedContent: String) {
        let copyItem = CopyItem(entity: CopyItem.entity(), insertInto: coreDataManager?.mainManagedObjectContext)
        copyItem.content = copiedContent
        copyItem.createdAt = Date()
        coreDataManager?.saveChanges()
    }
}

extension StatusBarItemController: CoreDataManagerDelegate {
    // MARK: - CoreDataManagerDelegate Methods

    func newItemInserted(atIndex indexPath: IndexPath) {
        guard let copyItem = coreDataManager?.getCopyItems()?.first else {
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
            action: #selector(StatusBarItemController.copyMenuItemTitleToPasteBoard(_:)),
            keyEquivalent: ""
        )
        menuItem.target = self
        menuItem.toolTip = copyItem.content
        menu.insertItem(menuItem, at: 0)
    }

    private func addSavedCopyItemsToMenu() {
        guard let copyItems = coreDataManager?.getCopyItems() else {
            return
        }

        for copyItem in copyItems {
            addCopyItemToMenu(copyItem: copyItem)
        }

        changeShortcutKeysForMenuItems()
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

    @objc func clearAllCopyItems(_ sender: Any?) {
        guard let copyItems = coreDataManager?.getCopyItems() else {
            return
        }

        for _ in 0..<copyItems.count {
            coreDataManager?.deleteItem(atIndex: IndexPath(item: 0, section: 0))
        }
    }

    @objc func copyMenuItemTitleToPasteBoard(_ sender: Any?) {
        guard let menuItem = sender as? NSMenuItem else {
            return
        }

        pasteboard.clearContents()
        pasteboard.setString(menuItem.title, forType: .string)
    }

    @objc func openPreferences(_ sender: Any?) {
        let windowController = PreferencesWindowController.instantiate()
        let settingsController = (windowController.window!.contentViewController as! PreferencesTabViewController)
        windowController.showWindow(self)
    }
}
