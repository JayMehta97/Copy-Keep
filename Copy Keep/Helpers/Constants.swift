//
//  Constants.swift
//  Copy Keep
//
//  Created by Jay Mehta on 06/07/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Foundation

struct Constants {

    struct Analytics {
        // MARK: - Analytic Event Names

        static let keepCopied = "Keep Copied"

        static let storeItemsCountChanged = "Store Items Count Changed"
        static let keepsDeleted = "Keeps Deleted"

        static let keepsCleared = "Keeps Cleared"
        static let keepsExported = "Keeps Exported"

        static let copyKeepStarted = "CopyKeep Started"
        static let copyKeepQuit = "CopyKeep Quit"

        // MARK: - Analytic Property Names

        static let numberOfItemsDeleted = "Number Of Items Deleted"
        static let newStoreItemsCount = "New Store Items Count"
    }

    struct Application {
        // MARK: - Properties

        static let appName = "Copy Keep"
        static let appUrl = "https://github.com/JayMehta97/Copy-Keep"
        static let launcherAppId = "com.jaymehta.apps.Auto-Launcher"
    }

    struct Common {
        // MARK: - Properties

        static let defaultStoreItems = 200
        static var storeItems = defaultStoreItems
    }

    struct CoreData {
        // MARK: - Properties

        static let coreDataModelName = "CopyKeep"
    }

    struct File {
        // MARK: - Properties

        static let copyKeepItemsJson = "CopyKeep Items.json"
    }

    struct Notification {
        // MARK: - Properties

        static let killLauncherNotificationName = "killLauncher"
    }

    struct UserDefaultsKeys {
        // MARK: - Properties

        static let storeItems = "storeItems"
    }
}
