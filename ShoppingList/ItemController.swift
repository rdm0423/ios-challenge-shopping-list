//
//  ItemController.swift
//  ShoppingList
//
//  Created by Ross McIlwaine on 5/20/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation
import CoreData

class ItemController {
    
    static let sharedController = ItemController()
    let fetchedResultsController: NSFetchedResultsController
    
    
    init() {
        let request = NSFetchRequest(entityName: "Item")
        let sortDescriptor1 = NSSortDescriptor(key: "isComplete", ascending: true)
        request.sortDescriptors = [sortDescriptor1]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Stack.sharedStack.managedObjectContext, sectionNameKeyPath: "isComplete", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error Trying to Perform Fetch")
        }
    }
    
    func addItem(name: String) {
        let _ = Item(name: name)
        saveToPersistentStorage()
    }
    
    func updateItem(item: Item, name: String) {
        item.name = name
        saveToPersistentStorage()
    }
    
    func removeItem(item: Item) {
        item.managedObjectContext?.deleteObject(item)
        saveToPersistentStorage()
    }
    
    func isCompleteValueToggled(item: Item) {
        item.isComplete = !item.isComplete.boolValue
        saveToPersistentStorage()
    }
    
    // MARK: Save to Persistent
    func saveToPersistentStorage() {
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Error Saving To Core Data")
        }
    }
}
