//
//  CopyItem+CoreDataClass.swift
//  Copy Keep
//
//  Created by Jay Mehta on 04/07/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CopyItem)
public class CopyItem: NSManagedObject {

    // MARK: - Properties

    var title: String {
        let maximumTitleLength = 45
        let trailingString = "..."

        if var itemTitle = content, itemTitle.count > maximumTitleLength {
            let numberOfCharactersToDrop = (itemTitle.count - maximumTitleLength) + trailingString.count
            itemTitle = itemTitle.dropLast(numberOfCharactersToDrop) + trailingString
            return itemTitle
        }

        return content ?? ""
    }
}
