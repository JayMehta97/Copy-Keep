//
//  Constants.swift
//  Copy Keep
//
//  Created by Jay Mehta on 06/07/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Foundation

enum Constants {

    enum Analytics {
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

    enum Application {
        // MARK: - Properties

        static let appName = "Copy Keep"
        static let appUrl = "https://github.com/JayMehta97/Copy-Keep"
        static let launcherAppId = "com.jaymehta.apps.Auto-Launcher"
    }

    enum Common {
        // MARK: - Properties

        static let defaultStoreItems = 200
        static var storeItems = defaultStoreItems
    }

    enum CoreData {
        // MARK: - Properties

        static let coreDataModelName = "CopyKeep"
    }

    enum File {
        // MARK: - Properties

        static let copyKeepItemsJson = "CopyKeep Items.json"
    }

    enum Notification {
        // MARK: - Properties

        static let killLauncherNotificationName = "killLauncher"
    }

    enum UserDefaultsKeys {
        // MARK: - Properties

        static let storeItems = "storeItems"
    }
}
