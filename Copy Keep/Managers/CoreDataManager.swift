//
//  CoreDataManager.swift
//  Copy Keep
//
//  Created by Jay Mehta on 04/07/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import CoreData
import Foundation

protocol CoreDataManagerDelegate: class {
    func newItemInserted(atIndex index: IndexPath)
    func itemDeleted(atIndex index: IndexPath)
}

enum Entity {
    case copyItem
}

class CoreDataManager: NSObject {

    // MARK: - Type Aliases

    public typealias CoreDataManagerCompletion = () -> Void

    // MARK: - Properties

    static let shared = CoreDataManager(modelName: Constants.CoreData.coreDataModelName)

    private let modelName: String
    private var fetchedCopyItemRC: NSFetchedResultsController<CopyItem>?

    private(set) var delegates = [CoreDataEntityDelegate]()

    // MARK: - Core Data Stack

    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator

        return managedObjectContext
    }()

    public lazy var mainManagedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        // Configure Managed Object Context
        managedObjectContext.parent = self.privateManagedObjectContext

        return managedObjectContext
    }()

    private lazy var managedObjectModel: NSManagedObjectModel = {
        // Fetch Model URL
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }

        // Initialize Managed Object Model
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }

        return managedObjectModel
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    }()

    // MARK: - Initialization

    public init(modelName: String) {

        // Set Properties
        self.modelName = modelName

        super.init()

        // Setup Core Data Stack
        setupCoreDataStack()
    }
}

extension CoreDataManager {
    // MARK: - Public API

    public func saveChanges() {
        mainManagedObjectContext.performAndWait {
            do {
                if self.mainManagedObjectContext.hasChanges {
                    try self.mainManagedObjectContext.save()
                }
            } catch {
                print("Unable to Save Changes of Main Managed Object Context")
                print("\(error), \(error.localizedDescription)")
            }
        }

        privateManagedObjectContext.perform {
            do {
                if self.privateManagedObjectContext.hasChanges {
                    try self.privateManagedObjectContext.save()
                }
            } catch {
                print("Unable to Save Changes of Private Managed Object Context")
                print("\(error), \(error.localizedDescription)")
            }
        }
    }

    public func privateChildManagedObjectContext() -> NSManagedObjectContext {
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        // Configure Managed Object Context
        managedObjectContext.parent = mainManagedObjectContext

        return managedObjectContext
    }

    public func getCopyItems() -> [CopyItem]? {
        fetchedCopyItemRC?.fetchedObjects ?? nil
    }
}

extension CoreDataManager {
    // MARK: - Helper Methods

    private func setupCoreDataStack() {
        // Fetch Persistent Store Coordinator
        guard let persistentStoreCoordinator = mainManagedObjectContext.persistentStoreCoordinator else {
            fatalError("Unable to Set Up Core Data Stack")
        }

        // Add Persistent Store
        self.addPersistentStore(to: persistentStoreCoordinator)

        // Setup Fetch Result Controller
        self.setupFetchResultController()
    }

    private func addPersistentStore(to persistentStoreCoordinator: NSPersistentStoreCoordinator) {
        // Helpers
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"

        // URL Documents Directory
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        // URL Persistent Store
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]

            // Add Persistent Store
            try persistentStoreCoordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: persistentStoreURL,
                options: options
            )
        } catch {
            fatalError("Unable to Add Persistent Store")
        }
    }

    private func setupFetchResultController() {
        let request = CopyItem.fetchRequest() as NSFetchRequest<CopyItem>
        do {
            let sort = NSSortDescriptor(key: #keyPath(CopyItem.createdAt), ascending: false)
            request.sortDescriptors = [sort]

            fetchedCopyItemRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: privateManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)

            fetchedCopyItemRC?.delegate = self

            try fetchedCopyItemRC?.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func addDelegate(coreDataManagerDelegate: CoreDataManagerDelegate, forEntity entity: Entity) {
        delegates.append(CoreDataEntityDelegate(coreDataManagerDelegate: coreDataManagerDelegate, entity: entity))
    }

    func deleteItem(atIndex index: IndexPath) {
        guard let item = fetchedCopyItemRC?.object(at: index) else {
            return
        }

        mainManagedObjectContext.delete(mainManagedObjectContext.object(with: item.objectID))

        saveChanges()
    }
}

extension CoreDataManager: NSFetchedResultsControllerDelegate {
    // MARK: - NSFetchedResultsControllerDelegate Methods

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        let index = indexPath ?? (newIndexPath ?? nil)
        guard let cellIndex = index else {
            return
        }

        switch type {
        case .insert:
            delegates.forEach({ delegate in
                if controller == fetchedCopyItemRC && delegate.entity == .copyItem {
                    delegate.coreDataManagerDelegate?.newItemInserted(atIndex: cellIndex)
                }
            })
        case .delete:
            delegates.forEach({ delegate in
                if controller == fetchedCopyItemRC && delegate.entity == .copyItem {
                    delegate.coreDataManagerDelegate?.itemDeleted(atIndex: cellIndex)
                }
            })
        case .update:
            print("Database Updated")
        default:
            break
        }
    }
}
