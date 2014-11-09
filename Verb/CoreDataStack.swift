//
//  CoreDataStack.swift
//  Verb
//
//  Created by Jonathan Porta on 11/4/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import CoreData

class CoreDataStack {
  let context: NSManagedObjectContext
  let psc: NSPersistentStoreCoordinator
  let model: NSManagedObjectModel
  let store: NSPersistentStore?

  init() {
    let bundle = NSBundle.mainBundle()
    let modelURL = bundle.URLForResource("Verb", withExtension: "momd")
    model = NSManagedObjectModel(contentsOfURL: modelURL!)!

    psc = NSPersistentStoreCoordinator(managedObjectModel: model)

    context = NSManagedObjectContext()
    context.persistentStoreCoordinator = psc

    let documentsURL = applicationDocumentsDirectory()
    let storeURL = documentsURL.URLByAppendingPathComponent("Verb")

    let options = [NSMigratePersistentStoresAutomaticallyOption: true]

    var error: NSError? = nil
    store = psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options, error: &error)

    if store == nil {
      println("Error adding persisten store: \(error)")
      abort()
    }
  }

  func saveContext() {
    var error: NSError? = nil
    if context.hasChanges && !context.save(&error) {
      println("Could not save: \(error), \(error?.userInfo)")
    }
  }

  func applicationDocumentsDirectory() -> NSURL {
    let fileManager = NSFileManager.defaultManager()

    let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]

    return urls[0]
  }


}
