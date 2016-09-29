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
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    
    var fetchedResultsController : NSFetchedResultsController? { // controls manages objects
        didSet {
            fetchedResultsController?.delegate = self
            completeSearch()
        } // end didSet
    } // end fetchedResultsController declaration
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData() // reload the data when view appears
        completeSearch() // fetch objects
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
        let stackContext = appDelegate.stack.context // get the context
        
        // Create a fetchrequest
        let fr = NSFetchRequest(entityName: "TaskHeader") // get the fetched items
        fr.sortDescriptors = []
        
        // Create the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr,
                                                              managedObjectContext: stackContext, sectionNameKeyPath: nil, cacheName: nil)

        tableView.reloadData() // reload the data after items are loaded into fetched results controller
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let taskCell = tableView.dequeueReusableCellWithIdentifier("taskHeaderCell", forIndexPath: indexPath)
        let taskInformation = fetchedResultsController?.objectAtIndexPath(indexPath) as! TaskHeader // get each taskHeader
        taskCell.textLabel!.text = taskInformation.taskTitle // set the title to be displayed
        taskCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator // set a discluser indiccator
        return taskCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // create the ViewController
        let allItemsVC = storyboard!.instantiateViewControllerWithIdentifier("AllItemsViewController") as! AllItemsViewController
        
        let headers = fetchedResultsController!.fetchedObjects as? [TaskHeader] // get the header array
        
        let clickedHeaderTitle = headers![indexPath.row] // get the selected header
        
        if let headers = fetchedResultsController!.fetchedObjects as? [TaskHeader] { // if the header exists, get the objects contained within it
            let headersAfterFilter = headers.filter({ (h: TaskHeader) -> Bool in
                return h.taskTitle == clickedHeaderTitle.taskTitle // if the titles match, get those objects
            })
            if let thisHeader = headersAfterFilter.first {
                //locationPin = thisPin
                let fetch = NSFetchRequest(entityName: "TaskItem") // fetch all items with TaskItem
                fetch.sortDescriptors = []
                let predicate = NSPredicate(format: "taskHeader = %@", thisHeader) // filter for items corresponding to TaskHeader
                fetch.predicate = predicate
                
                let fc = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: fetchedResultsController!.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
                
                let add = UIBarButtonItem(barButtonSystemItem: .Add, target: allItemsVC, action: Selector("AddItem")) // add a add button to the next view
                add.tintColor = UIColor(red:0.46, green:0.83, blue:0.52, alpha:1.0) // set its color
                allItemsVC.navigationItem.rightBarButtonItem = add // set the button to the view
                allItemsVC.fetchedResultsController = fc // set fetched results controller to next view
                
                allItemsVC.task = thisHeader // assign header for association
                //allItemsVC.title = clickedHeaderTitle.taskTitle
                allItemsVC.title = "My Items"

                //2. Present the view controller
                self.navigationController?.pushViewController(allItemsVC, animated: true)
                
            } // end if
        }// end if

        
        
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if fetchedResultsController?.fetchedObjects?.count > 0 { // get number of rows for the section based on CoreData
            count = (fetchedResultsController?.fetchedObjects?.count)!
        }
        return count
    }
    
    // segue for adding about me page
    @IBAction func aboutButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("PresentAboutTaskOutSegue", sender: self)
    }

    @IBAction func addTaskButtonPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier("AddTaskSegue", sender: self) // segue to adding a TaskHeader
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "AddTaskSegue") { // set the fetched results controller for the next view
            
            let addTaskVC = (segue.destinationViewController as! AddItemViewController)
            addTaskVC.fetchedResultsController = fetchedResultsController
            
        }
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


