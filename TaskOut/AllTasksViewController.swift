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
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        <#code#>
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

}

extension AllTasksViewController {
    
    func completeSearch(){
        if let fc = fetchedResultsController{
            do{
                try fc.performFetch()
            }catch let e as NSError{
                print("Error: could not performa a fetch")
            }
        }
    }
}


