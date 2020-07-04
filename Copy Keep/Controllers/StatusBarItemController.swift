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
            if index > 9 {
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
