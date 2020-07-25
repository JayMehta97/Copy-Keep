//
//  NSWindowController+Extensions.swift
//  Copy Keep
//
//  Created by Jay Mehta on 05/07/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Cocoa

extension NSWindowController {
    public static var defaultNib: String {
        return description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }

    public static var storyboardIdentifier: String {
        return description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
}

