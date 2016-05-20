//
//  ListTableViewController.swift
//  ShoppingList
//
//  Created by Ross McIlwaine on 5/20/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, ButtonTableViewCellDelegate {
    
    var item: Item?
    
    @IBOutlet var alertTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Shopping List"
        
        ItemController.sharedController.fetchedResultsController.delegate = self
        
        // set background image/color
        let backgroundImage = UIImage(named: "bg1main")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        // center and scale background image
        imageView.contentMode = .ScaleAspectFill

    }
    
    @IBAction func addItemButtonTapped(sender: AnyObject) {
        
        addGroceryItemAlert()
    }
    
    // MARK: UIAlertController
    
    func addGroceryItemAlert() {
        
        let alertController = UIAlertController(title: "Add to Grocery List", message: "What do you need from the store?", preferredStyle: .Alert)
        let addItemAction = UIAlertAction(title: "Add", style: .Default) { (_) in
            
            // Do add action here!
            if let field: UITextField = alertController.textFields![0] {
                
                // Create Item String to be Saved
                let groceryItem = Item(name: "\(field.text)")
                ItemController.sharedController.addItem(groceryItem.name)
                
                field.text = self.alertTextField.text
                
            } else {
                // did not type in field - add logic check
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in textField.placeholder = "Enter Item Here"
        }
        
        alertController.addAction(addItemAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        // Save on Close
//        ItemController.sharedController.saveToPersistentStorage()
        
//        tableView.reloadData()
    }
    
    func updateItem() {
        
        guard let name = alertTextField.text else {
            return
        }
        
        if let item = self.item {
            ItemController.sharedController.updateItem(item, name: name)
        } else {
            ItemController.sharedController.addItem(name)
        }
    }
    
    func updateWithItem(item: Item) {
        
        self.item = item
        
        alertTextField.text = item.name
    }
    


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return ItemController.sharedController.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = ItemController.sharedController.fetchedResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as? ButtonTableViewCell,
            let item = ItemController.sharedController.fetchedResultsController.objectAtIndexPath(indexPath) as? Item else {
                return ButtonTableViewCell()
        }
        cell.updateWithItem(item)
        cell.delegate = self

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            guard let item = ItemController.sharedController.fetchedResultsController.objectAtIndexPath(indexPath) as? Item else {
                return
            }
            ItemController.sharedController.removeItem(item)
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sections = ItemController.sharedController.fetchedResultsController.sections,
            index = Int(sections[section].name) else {
                return nil
        }
        if index == 0 {
            return "Need to Get"
        } else {
            return "Done"
        }
    }
    
    // MARK: Custom Background with Clear cells
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.2)
    }
    // MARK: Custom Background of Header Sections
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(white: 1, alpha: 0.5)
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        case .Delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case.Move:
            guard let indexPath = indexPath,
                newIndexPath = newIndexPath else {return}
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        case.Update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Move:
            break
        case .Update:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        tableView.endUpdates()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

    // MARK: - ButtonTableViewCellDelegate
    func buttonCellButtonTapped(sender: ButtonTableViewCell) {
        guard let indexPath = tableView.indexPathForCell(sender),
            item = ItemController.sharedController.fetchedResultsController.objectAtIndexPath(indexPath) as? Item else {return}
        ItemController.sharedController.isCompleteValueToggled(item)
        
    }
    
}
