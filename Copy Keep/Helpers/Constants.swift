//
//  Constants.swift
//  Copy Keep
//
//  Created by Jay Mehta on 06/07/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Foundation

struct Constants {

    // MARK: - Properties

    static let appName = "Copy Keep"

    static let launcherAppId = "com.jaymehta.apps.Auto-Launcher"
    static let killLauncherNotificationName = "killLauncher"

    static let coreDataModelName = "CopyKeep"

    static let defaultStoreItems = 200
    static var storeItems = defaultStoreItems
}

struct UserDefaultKeys {

    // MARK: - Properties

    static let storeItems = "storeItems"
}
