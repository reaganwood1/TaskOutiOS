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

    var fetchedResultsController : NSFetchedResultsController? {
        didSet {
            fetchedResultsController?.delegate = self
            completeSearch()
            //            mapDataReload()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stackContext = appDelegate.stack.context
        let fetchedRequest = NSFetchRequest(entityName: "TaskHeader")
        
        // Create a fetchrequest
        let fr = NSFetchRequest(entityName: "TaskHeader")
        fr.sortDescriptors = []
        
        // Create the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr,
                                                              managedObjectContext: stackContext, sectionNameKeyPath: nil, cacheName: nil)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let taskCell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath)
        let taskInformation = fetchedResultsController?.objectAtIndexPath(indexPath) as! TaskHeader
        //taskCell.detailTextLabel!.text = "Open to add or remove tasks"
        taskCell.textLabel!.text = taskInformation.taskTitle
        
        return taskCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        // create the ViewController
//        let photoVC = storyboard!.instantiateViewControllerWithIdentifier("PhotoAlbumCollectionViewController") as! PhotoCollectionViewController
//        //2. Present the view controller
//        self.navigationController?.pushViewController(photoVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if fetchedResultsController?.fetchedObjects?.count > 0 {
            count = (fetchedResultsController?.fetchedObjects?.count)!
        }
        return count
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "AddTaskSegue") { // set the fetched results controller for the next view
            
            let addTaskVC = (segue.destinationViewController as! AddItemViewController)
            addTaskVC.fetchedResultsController = fetchedResultsController
        } // end if
    }
    
    // on click for adding an item to the list
    func AddItem() {
        var x = 1
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
