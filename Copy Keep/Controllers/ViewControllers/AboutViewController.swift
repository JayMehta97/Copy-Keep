//
//  AboutViewController.swift
//  Copy Keep
//
//  Created by Jay Mehta on 27/07/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Cocoa

class AboutViewController: NSViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var emailShareButton: NSButton!
    @IBOutlet private weak var messageShareButton: NSButton!
    @IBOutlet private weak var copyLinkButton: NSButton!

    // MARK: - Properties

    private let aboutVM = AboutViewModel()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup
        setup()
    }

    // MARK: - User Interactions Methods

    @IBAction func emailShareButtonClicked(_ sender: NSButton) {
        shareAppWithSharingService(forService: .composeEmail)
    }

    @IBAction func messageShareButton(_ sender: NSButton) {
        shareAppWithSharingService(forService: .composeMessage)
    }

    @IBAction func copyLinkButtonClicked(_ sender: NSButton) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(Constants.Application.appUrl, forType: .string)
    }

    @IBAction func rateUsOnAppStoreButtonClicked(_ sender: NSButton) {
    }

    @IBAction func writeToUsButtonClicked(_ sender: NSButton) {
    }

}

extension AboutViewController {
    // MARK: - Setup methods

    private func setupShareButton() {
        emailShareButton.toolTip = aboutVM.emailButtonToolTip
        messageShareButton.toolTip = aboutVM.messageButtonToolTip
        copyLinkButton.toolTip = aboutVM.copyLinkButtonToolTip
    }

    private func setup() {
        setupShareButton()
    }
}

extension AboutViewController {
    // MARK: - Helper methods

    private func shareAppWithSharingService(forService serviceName: NSSharingService.Name) {
        guard let shareService = NSSharingService(named: serviceName), let appUrl = URL(string: Constants.Application.appUrl) else {
            return
        }

        shareService.perform(withItems: [appUrl])
    }
}
