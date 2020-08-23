//
//  CopyItem+CoreDataProperties.swift
//  Copy Keep
//
//  Created by Jay Mehta on 04/07/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//
//

import CoreData
import Foundation

extension CopyItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CopyItem> {
        NSFetchRequest<CopyItem>(entityName: "CopyItem")
    }

    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
}
