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
        generalPreferencesVM.deleteItems(forIndexes: copiedItemsTableView.selectedRowIndexes)
        setupDeleteItemsButton(forSelectedItems: 0)
    }

}

extension GeneralPreferencesViewController {
    // MARK: - Setup methods

    private func setupCopiedTableView() {
        self.copiedItemsTableView.dataSource = self
        self.copiedItemsTableView.delegate = self
    }

    private func setupDeleteItemsButton(forSelectedItems selectedItems: Int) {
        deleteItemsButton.isEnabled = selectedItems >= generalPreferencesVM.minimumNumberOfSelectedItemsToDelete
        deleteItemsButton.title = generalPreferencesVM.getTitleForDeleteItemsButton(selectedItems: selectedItems)
    }

    private func setup() {
        generalPreferencesVM.fetchCopyItems()

        setupCopiedTableView()
        setupDeleteItemsButton(forSelectedItems: 0)

        numberOfItemToStoreTextField.stringValue = Constants.storeItems.description
        numberOfItemToStoreTextField.delegate = self

        // Add GeneralPreferencesVC to CoreDataManager's delegate list to receive database changes events
        CoreDataManager.shared.addDelegate(coreDataManagerDelegate: self, forEntity: .copyItem)
    }
}

extension GeneralPreferencesViewController: NSTableViewDataSource {
    // MARK: - NSTableViewDataSource methods

    func numberOfRows(in tableView: NSTableView) -> Int {
        return generalPreferencesVM.copyItems.count
    }
}

extension GeneralPreferencesViewController: NSTableViewDelegate {
    // MARK: - NSTableViewDelegate methods

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = copiedItemsTableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: generalPreferencesVM.copiedItemsTableViewCellId), owner: nil) as? NSTableCellView else {
            return nil
        }
        cell.textField?.stringValue = generalPreferencesVM.copyItems[row].content ?? ""
        cell.toolTip = generalPreferencesVM.copyItems[row].content ?? ""
        return cell
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = notification.object as? NSTableView else {
            return
        }

        setupDeleteItemsButton(forSelectedItems: tableView.selectedRowIndexes.count)
    }
}

extension GeneralPreferencesViewController: CoreDataManagerDelegate {
    // MARK: - CoreDataManagerDelegate Methods

    func newItemInserted(atIndex indexPath: IndexPath) {
        generalPreferencesVM.fetchCopyItems()
        copiedItemsTableView.insertRows(at: IndexSet(integer: 0), withAnimation: .slideDown)
    }

    func itemDeleted(atIndex index: IndexPath) {
        generalPreferencesVM.fetchCopyItems()
        copiedItemsTableView.removeRows(at: IndexSet(integer: index.item), withAnimation: .slideUp)
    }
}

extension GeneralPreferencesViewController: NSTextFieldDelegate {
    // MARK: - NSTextFieldDelegate Methods

    func controlTextDidEndEditing(_ obj: Notification) {
        guard let storeItemsString = (obj.userInfo?["NSFieldEditor"] as? NSTextView)?.string, let storeItems = Int(storeItemsString), storeItems >= 0 else {
            numberOfItemToStoreTextField.stringValue = Constants.storeItems.description
            return
        }

        if storeItems < generalPreferencesVM.copyItems.count, let window = view.window {
            alertDialog(withTitle: generalPreferencesVM.getAlertTitle(forStoreItems: storeItems), message: generalPreferencesVM.getAlertMessage(forStoreItems: storeItems)).beginSheetModal(for: window) { response in
                if response == .alertFirstButtonReturn {
                    self.generalPreferencesVM.deleteAllItems(fromIndex: storeItems)
                    self.saveStoreItems(storeItems: storeItems)
                } else {
                    self.numberOfItemToStoreTextField.stringValue = Constants.storeItems.description
                }
            }
        } else {
            saveStoreItems(storeItems: storeItems)
        }
    }
}

extension GeneralPreferencesViewController {
    // MARK: - Helper Methods

    private func saveStoreItems(storeItems: Int) {
        Constants.storeItems = storeItems
        UserDefaults.standard.set(storeItems, forKey: UserDefaultKeys.storeItems)
    }

    private func alertDialog(withTitle title: String, message: String) -> NSAlert {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .critical
        alert.addButton(withTitle: generalPreferencesVM.alertOkButtonTitle)
        alert.addButton(withTitle: generalPreferencesVM.alertCancelButtonTitle)
        return alert
    }
}
