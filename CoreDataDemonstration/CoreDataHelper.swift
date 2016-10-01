//
//  CoreDataHelper.swift
//  CoreDataDemonstration
//
//  Created by James Park on 2016-09-28.
//  Copyright © 2016 James Park. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    let model = "CoreDataDemonstration"
    
    /*
     A private property, it holds the location where the Core Data will store the data.
     It will use the application document directory as the location which is the recommended place to store the data.
     */
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        return urls[urls.count-1]
    }()
    
    /*
     A private property, represents object in the data model, including information on the model's property and its relationship.
     This is the reason we need to pass in our data model name in this property. As in this case,
     we name the xcdatamodeld file as "RocketCast.xcdatamodeld" and that's why we pass in the same exact name to managedObjectModel.
     */
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(self.model, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    /*
     A private property, this coordinator is what makes things work for Core Data.
     It orchestrated the connection between the managed object model and the persistent store.
     It is responsible in doing the heavy lifting of handling Core Data implementation.
     */
    private lazy var persistenceStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.model)
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true]
            
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        }
        catch {
            print("Error adding persistence store")
        }
        
        return coordinator
    }()
    
    /*
     A public property, this is our only accessible property from the Core Data stack.
     It has to connect to a persistenceStoreCoordinator so we can work with the managedObject in our data store.
     It also manages the lifecycle of our objects.
     */
    lazy var managedObjectContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistenceStoreCoordinator
        return context
    }()
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Saved a new managed object")
            }
            catch let error as NSError {
            
                print("Error saving context: " + error.localizedDescription)
            }
        }
    }

    
    
}