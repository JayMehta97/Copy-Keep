//
//  Storyboard.swift
//  Copy Keep
//
//  Created by Jay Mehta on 05/07/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Cocoa

enum Storyboard: String {
    // swiftlint:disable identifier_name
    case Main
    // swiftlint:enable identifier_name

    public func instantiate<VC: NSViewController>(_ viewController: VC.Type, inBundle bundle: Bundle = Bundle.main) -> VC {
        guard let viewController = NSStoryboard(name: self.rawValue, bundle: bundle).instantiateController(withIdentifier: VC.storyboardIdentifier) as? VC else {
            fatalError("Couldn't instantiate \(VC.storyboardIdentifier) from \(self.rawValue)")
        }
        return viewController
    }

    public func instantiate<WC: NSWindowController>(_ viewController: WC.Type, inBundle bundle: Bundle = Bundle.main) -> WC {
        guard let windowController = NSStoryboard(name: self.rawValue, bundle: bundle).instantiateController(withIdentifier: WC.storyboardIdentifier) as? WC else {
            fatalError("Couldn't instantiate \(WC.storyboardIdentifier) from \(self.rawValue)")
        }
        return windowController
    }
}
