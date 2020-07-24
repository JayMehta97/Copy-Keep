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

    let copiedItemsTableViewCellId = "CopiedItemsTableViewCell"
    let minimumNumberOfSelectedItemsToDelete = 1

    // MARK: - Get methods

    func getTitleForDeleteItemsButton(selectedItems: Int) -> String {
        return "Delete \(selectedItems) " + (selectedItems > 1 ? "Items" : "Item")
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
}
