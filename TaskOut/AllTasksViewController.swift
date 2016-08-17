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
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        completeSearch()
    }
    
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
        
        let taskCell = tableView.dequeueReusableCellWithIdentifier("taskHeaderCell", forIndexPath: indexPath)
        let taskInformation = fetchedResultsController?.objectAtIndexPath(indexPath) as! TaskHeader
        taskCell.detailTextLabel!.text = "Open to add or remove tasks"
        taskCell.textLabel!.text = taskInformation.taskTitle
        
        return taskCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // create the ViewController
        let allItemsVC = storyboard!.instantiateViewControllerWithIdentifier("AllItemsViewController") as! AllItemsViewController
        
        let headers = fetchedResultsController!.fetchedObjects as? [TaskHeader]
        
        let clickedHeaderTitle = headers![indexPath.row]
        
        if let headers = fetchedResultsController!.fetchedObjects as? [TaskHeader] {
            let headersAfterFilter = headers.filter({ (h: TaskHeader) -> Bool in
                return h.taskTitle == clickedHeaderTitle.taskTitle
            })
            if let thisHeader = headersAfterFilter.first {
                //locationPin = thisPin
                let fetch = NSFetchRequest(entityName: "TaskItem")
                fetch.sortDescriptors = []
                let predicate = NSPredicate(format: "taskHeader = %@", thisHeader)
                fetch.predicate = predicate
                
                let fc = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: fetchedResultsController!.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
                
                let camera = UIBarButtonItem(barButtonSystemItem: .Add, target: allItemsVC, action: Selector("AddItem"))
                allItemsVC.navigationItem.rightBarButtonItem = camera
                allItemsVC.fetchedResultsController = fc
                
                //2. Present the view controller
                self.navigationController?.pushViewController(allItemsVC, animated: true)
                
            } // end if
        }// end if

        
        
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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


// MARK:  - Delegate
extension AllTasksViewController{
    
    
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
        
        guard let newIndexPath = newIndexPath else{
            fatalError("No indexPath received")
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


