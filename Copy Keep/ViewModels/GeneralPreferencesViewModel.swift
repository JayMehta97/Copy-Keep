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
        return "Delete \(selectedItems) Items"
    }

}
