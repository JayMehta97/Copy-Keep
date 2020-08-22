//
//  AnalyticsManager.swift
//  Copy Keep
//
//  Created by Jay Mehta on 17/08/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

import Foundation

class AnalyticsManager {

    // MARK: - Properties

    static let shared = AnalyticsManager()

    // MARK: - Init

    func initialize() {
        print(Secrets.appCenterAppSecret)
        MSAppCenter.start(Secrets.appCenterAppSecret, withServices: [MSAnalytics.self, MSCrashes.self])
    }

    // MARK: - Event tracking methods

    func track(eventName: String) {
        MSAnalytics.trackEvent(eventName)
    }

    func track(eventName: String, eventParameters: [String: String]) {
        MSAnalytics.trackEvent(eventName, withProperties: eventParameters)
    }
}
