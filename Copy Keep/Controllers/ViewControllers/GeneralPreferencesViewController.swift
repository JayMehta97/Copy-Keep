//
//  GeneralPreferencesViewController.swift
//  Copy Keep
//
//  Created by Jay Mehta on 05/07/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Cocoa

class GeneralPreferencesViewController: NSViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var numberOfItemToStoreTextField: NSTextField!
    @IBOutlet private weak var copiedItemsTableView: NSTableView!

    // MARK: - Properties

    var coreDataManager: CoreDataManager?
    private var copyItems = [CopyItem]()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        copiedItemsTableView.dataSource = self
        copiedItemsTableView.delegate = self
    }
    
}

extension GeneralPreferencesViewController {
    // MARK: - Setup methods

    private func setup() {
        copyItems = coreDataManager?.getCopyItems() ?? []
    }
}

extension GeneralPreferencesViewController: NSTableViewDataSource {
    // MARK: - NSTableViewDataSource methods

    func numberOfRows(in tableView: NSTableView) -> Int {
        return copyItems.count
    }
}

extension GeneralPreferencesViewController: NSTableViewDelegate {
    // MARK: - NSTableViewDelegate methods

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = copiedItemsTableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CopiedItemCell"), owner: nil) as? NSTableCellView else {
            return nil
        }
        cell.textField?.stringValue = copyItems[row].content ?? ""
        cell.toolTip = copyItems[row].content ?? ""
        return cell
    }
}
