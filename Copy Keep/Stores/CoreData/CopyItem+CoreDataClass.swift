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

    private let maximumTitleLength = 45
    private let trailingString = "..."

    var title: String {
        if var itemTitle = content, itemTitle.count > maximumTitleLength {
            let numberOfCharactersToDrop = itemTitle.count - maximumTitleLength - trailingString.count
            itemTitle = itemTitle.dropLast(numberOfCharactersToDrop) + trailingString
            return itemTitle
        }

        return content ?? ""
    }
}
