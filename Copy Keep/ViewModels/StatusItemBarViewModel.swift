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

    // MARK: - Helper methods

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

    private func checkIfCopyItemsHavedReachedLimit() {
        guard let copyItems = CoreDataManager.shared.getCopyItems() else {
            return
        }

        if copyItems.count > Constants.storeItems {
            for index in IndexSet(integersIn: Constants.storeItems..<copyItems.count).reversed() {
                CoreDataManager.shared.deleteItem(atIndex: IndexPath(item: index, section: 0))
            }
        }
    }

    func exportCopyItems(toFileUrl fileUrl: URL) {
        // Transform array into data and save it into file
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(getCopyKeepExportData().self)
            try data.write(to: fileUrl, options: .atomicWrite)
        } catch {
            print(error)
        }
    }

    private func getCopyKeepExportData() -> [CopyKeepExportItem] {
        guard let copyItems = CoreDataManager.shared.getCopyItems() else {
            return []
        }

        var copyKeepExportItems = [CopyKeepExportItem]()
        for copyItem in copyItems {
            if let content = copyItem.content, let createdAt = copyItem.createdAt {
                copyKeepExportItems.append(CopyKeepExportItem(content: content, createdAt: createdAt.description))
            }
        }
        return copyKeepExportItems
    }
}

// MARK: - CoreData Operations
extension StatusItemBarViewModel {

    // MARK: - Get data methods

    func getCopyItems() -> [CopyItem]? {
        return CoreDataManager.shared.getCopyItems()
    }

    // MARK: - Insert data methods

    func addCopyItem(forCopiedContent copiedContent: String) {
        guard shouldCopyItemBeSaved(forCopiedContent: copiedContent) else {
            return
        }
        let copyItem = CopyItem(entity: CopyItem.entity(), insertInto: CoreDataManager.shared.mainManagedObjectContext)
        copyItem.content = copiedContent
        copyItem.createdAt = Date()
        CoreDataManager.shared.saveChanges()

        // If copy items exceed store items then delete older copy items.
        checkIfCopyItemsHavedReachedLimit()
    }

    // MARK: - Remove data methods

    func clearAllCopyItems() {
        guard let copyItems = CoreDataManager.shared.getCopyItems() else {
            return
        }

        for _ in 0..<copyItems.count {
            CoreDataManager.shared.deleteItem(atIndex: IndexPath(item: 0, section: 0))
        }
    }
}

