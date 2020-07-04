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
    static let killLauncher = Notification.Name("killLauncher")
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItemController: StatusBarItemController?

    // MARK: - Application Life Cycle

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        killLauncherApplication()
        statusBarItemController = StatusBarItemController()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

extension AppDelegate {
    // MARK: - Launcher related methods

    private func killLauncherApplication() {
        let launcherAppId = "com.jaymehta.apps.Auto-Launcher"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppId }.isEmpty

        SMLoginItemSetEnabled(launcherAppId as CFString, true)

        if isRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher, object: Bundle.main.bundleIdentifier!)
        }
    }
}

