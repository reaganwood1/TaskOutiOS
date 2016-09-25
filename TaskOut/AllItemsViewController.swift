//
//  AllItemsViewController.swift
//  TaskOut
//
//  Created by Reagan Wood on 8/17/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AllItemsViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var task: TaskHeader?
    
    var fetchedResultsController : NSFetchedResultsController? {
        didSet {
            fetchedResultsController?.delegate = self
            completeSearch()
        } // end didSet
    } // end fetchedResultsController declaration
    
    init(fetchedResultsController fc : NSFetchedResultsController) {
        fetchedResultsController = fc
        super.init(nibName: nil, bundle: nil)
    }
    
    // code for objective C
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        completeSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let taskCell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath)
        let taskInformation = fetchedResultsController?.objectAtIndexPath(indexPath) as! TaskItem
        //taskCell.detailTextLabel!.text = "Open to add or remove tasks"
        taskCell.textLabel!.text = taskInformation.title
        
        return taskCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let itemOfTask = fetchedResultsController!.objectAtIndexPath(indexPath) as! TaskItem
//        self.fetchedResultsController!.managedObjectContext.deleteObject(itemOfTask) // delete the item
//        do { // added so data context change is saved in coreData
//            try self.fetchedResultsController!.managedObjectContext.save()
//            self.completeSearch()
//            tableView.reloadData()
//        }catch {
//            print("nothing was saved")
//        }
        self.displayAlert("", message: "Remove Item: \(itemOfTask.title!)", actionTitle1: "Cancel", actionTitle2: "Remove", item: itemOfTask)

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if fetchedResultsController?.fetchedObjects?.count > 0 {
            count = (fetchedResultsController?.fetchedObjects?.count)!
        }
        return count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "addItemUnderHeader") { // set the fetched results controller for the next view
            
            let addTaskVC = (segue.destinationViewController as! AddItemForHeaderViewController)
            addTaskVC.task = task // assign the task header so item can be added to it
            addTaskVC.fetchedResultsController = fetchedResultsController
        } // end if
    }
    
    // on click for adding an item to the list
    func AddItem() {
        self.performSegueWithIdentifier("addItemUnderHeader", sender: self)
    }
    
    
    // blanket alert view template function
    func displayAlert(headTitle: String?, message: String?, actionTitle1: String?, actionTitle2: String?, item: TaskItem){
        
        // run the alert in the main queue because it's a member of UIKit
        dispatch_async(dispatch_get_main_queue(), {()-> Void in
            
            let alert = UIAlertController(title: headTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: actionTitle1, style: .Default, handler: { action in
                
            }))
            
            if let actionTitle2 = actionTitle2 { // deletion case
                alert.addAction(UIAlertAction(title: actionTitle2, style: .Default, handler: { action in
                    self.fetchedResultsController!.managedObjectContext.deleteObject(item) // delete the item
                    do { // added so data context change is saved in coreData
                        try self.fetchedResultsController!.managedObjectContext.save()
                        self.completeSearch()
                        self.tableView.reloadData()
                    }catch {
                        print("nothing was saved")
                    }
                }))
            }
            self.presentViewController(alert, animated: true, completion: nil)
            
        }) // end image main queue completion handler
    }
}

extension AllItemsViewController{
    
    func completeSearch(){
        if let fc = fetchedResultsController{
            do{
                try fc.performFetch()
            }catch let e as NSError{
                print("Error: could not performa a fetch \(e)")
            }
        }
    }
}

// MARK:  - Delegate
extension AllItemsViewController{
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
                    didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                                     atIndex sectionIndex: Int,
                                             forChangeType type: NSFetchedResultsChangeType) {
        
        let set = NSIndexSet(index: sectionIndex)
        
        switch (type){
            
        case .Insert:
            tableView.insertSections(set, withRowAnimation: .Fade)
            
        case .Delete:
            tableView.deleteSections(set, withRowAnimation: .Fade)
            
        default:
            // irrelevant in our case
            break
            
        }
    }
    
    
    func controller(controller: NSFetchedResultsController,
                    didChangeObject anObject: AnyObject,
                                    atIndexPath indexPath: NSIndexPath?,
                                                forChangeType type: NSFetchedResultsChangeType,
                                                              newIndexPath: NSIndexPath?) {
        
        guard let newIndexPath = indexPath else{
            return
        }
        switch(type){
            
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            
        case .Delete:
            tableView.deleteRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            
        case .Update:
            tableView.reloadRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            
        case .Move:
            tableView.deleteRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}