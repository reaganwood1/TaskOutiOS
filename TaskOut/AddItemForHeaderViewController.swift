//
//  AddItemForHeaderViewController.swift
//  TaskOut
//
//  Created by Reagan Wood on 8/17/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddItemForHeaderViewController: UIViewController, NSFetchedResultsControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var enterItemTextField: UITextView!
    @IBOutlet weak var addItemButton: UIButton!
    var task: TaskHeader?
    
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
        enterItemTextField.delegate = self
    }
    
    @IBAction func addItemButtonPressed(sender: AnyObject) {
        if (enterItemTextField.text != "Enter Task Header" && enterItemTextField.text != "") {
            let item = TaskItem(title: enterItemTextField.text, context: (fetchedResultsController?.managedObjectContext)!)
            item.taskHeader = task // assign header for the task
            
            do { // saves to the context so network is not hit unnecessarily again
                try self.fetchedResultsController!.managedObjectContext.save()
            }catch {
                print("nothing was saved")
            }
            completeSearch()
            self.dismissViewControllerAnimated(true, completion: {
                
            })// end completion
        } else {
            print ("please enter text")
        } // end if

    }
}

extension AddItemForHeaderViewController {
    
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
