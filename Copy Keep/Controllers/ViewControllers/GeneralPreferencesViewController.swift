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
    @IBOutlet private weak var deleteItemsButton: NSButton!

    // MARK: - Properties

    private var copyItems = [CopyItem]()
    private let generalPreferencesVM = GeneralPreferencesViewModel()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        // Setup
        self.setup()
    }

    // MARK: - User Interactions Methods

    @IBAction private func deleteItemsButtonPressed(_ sender: NSButton) {
    }

}

extension GeneralPreferencesViewController {
    // MARK: - Setup methods

    private func setupCopiedTableView() {
        self.copiedItemsTableView.dataSource = self
        self.copiedItemsTableView.delegate = self
        self.copiedItemsTableView.action = #selector(copiedItemsTableViewRowClicked)
    }

    private func setupDeleteItemsButton(forSelectedItems selectedItems: Int) {
        deleteItemsButton.isEnabled = selectedItems >= generalPreferencesVM.minimumNumberOfSelectedItemsToDelete
        deleteItemsButton.title = generalPreferencesVM.getTitleForDeleteItemsButton(selectedItems: selectedItems)
    }

    private func setup() {
        copyItems = CoreDataManager.shared.getCopyItems() ?? []
        setupCopiedTableView()
        setupDeleteItemsButton(forSelectedItems: 0)
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
        guard let cell = copiedItemsTableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: generalPreferencesVM.copiedItemsTableViewCellId), owner: nil) as? NSTableCellView else {
            return nil
        }
        cell.textField?.stringValue = copyItems[row].content ?? ""
        cell.toolTip = copyItems[row].content ?? ""
        return cell
    }
}

extension GeneralPreferencesViewController {
    // MARK: - TableView interaction methods

    @objc func copiedItemsTableViewRowClicked() {
        setupDeleteItemsButton(forSelectedItems: copiedItemsTableView.selectedRowIndexes.count)
    }
}
