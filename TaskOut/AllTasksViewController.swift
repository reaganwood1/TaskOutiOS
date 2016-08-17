//
//  ViewController.swift
//  TaskOut
//
//  Created by Reagan Wood on 8/16/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import UIKit
import CoreData

class AllTasksViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var addTaskButton: UIBarButtonItem!
    
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
        
//        do {
//            let results = try stackContext.executeFetchRequest(fetchedRequest)
//            pins = results as! [NSManagedObject]
//            addPinsToMap()
//        } catch {
//            print("error retrieving NSFetchedResultsController")
//        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let taskCell = tableView.dequeueReusableCellWithIdentifier("taskHeaderCell", forIndexPath: indexPath)
        let taskInformation = fetchedResultsController?.objectAtIndexPath(indexPath) as! TaskHeader
        taskCell.detailTextLabel!.text = "Open to add or remove tasks"
        taskCell.textLabel!.text = taskInformation.taskTitle
        
        return taskCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var count = 0
        
        if fetchedResultsController?.fetchedObjects?.count > 0 {
            count = (fetchedResultsController?.fetchedObjects?.count)!
        }
        return count
    }

    @IBAction func addTaskButtonPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier("AddTaskSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "AddTaskSegue") { // set the fetched results controller for the next view
            
            let addTaskVC = (segue.destinationViewController as! AddItemViewController)
            addTaskVC.fetchedResultsController = fetchedResultsController
        } // end if
    }
}

extension AllTasksViewController {
    
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


