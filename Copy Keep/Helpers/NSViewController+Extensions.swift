//
//  NSViewController+Extensions.swift
//  Copy Keep
//
//  Created by Jay Mehta on 05/07/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Cocoa

extension NSViewController {
    public static var defaultNib: String {
        description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }

    public static var storyboardIdentifier: String {
        description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
}
