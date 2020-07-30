//
//  GeneralPreferencesViewModel.swift
//  Copy Keep
//
//  Created by Jay Mehta on 24/07/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Foundation

class GeneralPreferencesViewModel {

    // MARK: - Properties

    private(set) var copyItems = [CopyItem]()

    let copiedItemsTableViewCellId = "CopiedItemsTableViewCell"
    let minimumNumberOfSelectedItemsToDelete = 1

    let alertOkButtonTitle = "OK"
    let alertCancelButtonTitle = "Cancel"

    // MARK: - Helper method

    func fetchCopyItems() {
        copyItems = CoreDataManager.shared.getCopyItems() ?? []
    }

    func getTitleForDeleteItemsButton(selectedItems: Int) -> String {
        return "Delete \(selectedItems) " + (selectedItems > 1 ? "Items" : "Item")
    }

    func getStoreItemsChangeAlertTitle(forStoreItems storeItems: Int) -> String {
        return "This will delete \(copyItems.count - storeItems) older items. Are you sure?"
    }

    func getStoreItemsChangeAlertMessage(forStoreItems storeItems: Int) -> String {
        return "Decreasing store items value to lower than currently stored copied items will delete \(copyItems.count - storeItems) older items"
    }

    func getDeleteItemsAlertTitle(forSelectedItems selectedItems: Int) -> String {
        return "Are you sure you want to delete \(selectedItems) selected items?"
    }

}

// MARK: - CoreData Operations
extension GeneralPreferencesViewModel {

    // MARK: - Get data methods

    func getCopyItems() -> [CopyItem]? {
        return CoreDataManager.shared.getCopyItems()
    }

    // MARK: - Remove data methods

    func deleteItems(forIndexes indexes: IndexSet) {
        for index in indexes.reversed() {
            CoreDataManager.shared.deleteItem(atIndex: IndexPath(item: index, section: 0))
        }
    }

    func deleteAllItems(fromIndex index: Int) {
        deleteItems(forIndexes: IndexSet(integersIn: index..<copyItems.count))
    }
}
