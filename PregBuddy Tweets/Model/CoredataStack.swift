//
//  CoredataStack.swift
//  PregBuddy Tweets
//
//  Created by Ashiq Sulaiman on 06/03/18.
//  Copyright © 2018 Ashiq Sulaiman. All rights reserved.
//

import Foundation
import Foundation
import CoreData

class CoreDataStack{
    static let sharedInstance = CoreDataStack()
    
    //private init() -> to prevent multiple instances
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSavePrivateQueueContext), name: NSNotification.Name.NSManagedObjectContextDidSave, object: self.privateQueueContext)
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSaveMainQueueContext), name: NSNotification.Name.NSManagedObjectContextDidSave, object: self.mainQueueContext)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "PregBuddy_Tweets")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentContainer.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var privateQueueContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentContainer.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    
    // MARK: - Core Data Saving support
    
    open class func saveContext(_ context: NSManagedObjectContext?) {
        if let moc = context {
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch {
                    print("failed to save context")
                }
            }
        }
    }
    
    // MARK: - Notifications
    
    @objc func contextDidSavePrivateQueueContext(_ notification: Notification) {
        self.synced(self, closure: { () -> () in
            self.mainQueueContext.perform({() -> Void in
                self.mainQueueContext.mergeChanges(fromContextDidSave: notification)
            })
        })
    }
    
    @objc func contextDidSaveMainQueueContext(_ notification: Notification) {
        self.synced(self, closure: { () -> () in
            self.privateQueueContext.perform({() -> Void in
                self.privateQueueContext.mergeChanges(fromContextDidSave: notification)
            })
        })
    }
    
    func synced(_ lock: AnyObject, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    
}

extension CoreDataStack {
    
    func applicationDocumentsDirectory() {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "yo.BlogReaderApp" in the application's documents directory.
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}

