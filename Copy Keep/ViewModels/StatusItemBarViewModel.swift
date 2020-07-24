//
//  StatusItemBarViewModel.swift
//  Copy Keep
//
//  Created by Jay Mehta on 04/07/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Foundation

class StatusItemBarViewModel {

    // MARK: - Properties

    let statusBarImageName = "icon"

    let quitMenuItemTitle = "Quit"
    let quitMenuItemKey = "q"

    let clearMenuItemTitle = "Clear"
    let clearMenuItemKey = ""

    let exportMenuItemTitle = "Export"
    let exportMenuItemKey = "e"

    let preferencesMenuItemTitle = "Preferences"
    let preferencesMenuItemKey = ","

    let watchBoardCheckTimeFrequency = 1.0

    private let thresholdToForDuplicateCopy = 10
    let maximumMenuItemsWithKeys = 10

    // MARK: - Core data methods

    func getCopyItems() -> [CopyItem]? {
        return CoreDataManager.shared.getCopyItems()
    }

    private func shouldCopyItemBeSaved(forCopiedContent copiedContent: String) -> Bool {
        guard let copyItems = CoreDataManager.shared.getCopyItems() else {
            return true
        }

        for (index, copyItem) in zip(copyItems.indices, copyItems) {
            if index >= thresholdToForDuplicateCopy {
                break
            }

            if copyItem.content == copiedContent {
                return false
            }
        }
        return true
    }

    func addCopyItem(forCopiedContent copiedContent: String) {
        guard shouldCopyItemBeSaved(forCopiedContent: copiedContent) else {
            return
        }
        let copyItem = CopyItem(entity: CopyItem.entity(), insertInto: CoreDataManager.shared.mainManagedObjectContext)
        copyItem.content = copiedContent
        copyItem.createdAt = Date()
        CoreDataManager.shared.saveChanges()
    }

    func clearAllCopyItems() {
        guard let copyItems = CoreDataManager.shared.getCopyItems() else {
            return
        }

        for _ in 0..<copyItems.count {
            CoreDataManager.shared.deleteItem(atIndex: IndexPath(item: 0, section: 0))
        }
    }
}

