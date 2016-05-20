//
//  Item.swift
//  ShoppingList
//
//  Created by Ross McIlwaine on 5/20/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
class Item: NSManagedObject {

// Conveniene Initializer

    convenience init(name: String, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Item", inManagedObjectContext: context)!
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
        self.isComplete = false
        
        
    }
    
    
}
