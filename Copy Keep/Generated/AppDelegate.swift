//
//  AppDelegate.swift
//  Copy Keep
//
//  Created by Jay Mehta on 04/07/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Cocoa
import ServiceManagement

extension Notification.Name {
    static let killLauncher = Notification.Name(Constants.killLauncherNotificationName)
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItemController: StatusBarItemController?

    // MARK: - Application Life Cycle

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        killLauncherApplication()
        setUserDefaults()
        statusBarItemController = StatusBarItemController()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

extension AppDelegate {
    // MARK: - Launcher related methods

    private func killLauncherApplication() {
        let launcherAppId = Constants.launcherAppId
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppId }.isEmpty

        SMLoginItemSetEnabled(launcherAppId as CFString, true)

        if isRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher, object: Bundle.main.bundleIdentifier!)
        }
    }
}

extension AppDelegate {
    // MARK: - Setup methods

    private func setUserDefaults() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: UserDefaultKeys.storeItems) != nil {
            Constants.storeItems = defaults.integer(forKey: UserDefaultKeys.storeItems)
        }
    }
}

