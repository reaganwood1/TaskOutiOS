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
    @IBOutlet weak var cancelButton: UIButton!
    
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
    
    func textViewDidBeginEditing(textView: UITextView) {
        if (textView.text == "Enter Task Item") {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == "") {
            textView.text = "Enter Task Item"
        }
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
        }
    }
    @IBAction func addItemButtonPressed(sender: AnyObject) {
        if (enterItemTextField.text != "Enter Task Item" && enterItemTextField.text != "") {
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
            displayEmptyAlert("", message: "Please Enter a Task Item Title to Save", actionTitle: "Ok")
        } // end if

    }
    
    func displayEmptyAlert(headTitle: String?, message: String?, actionTitle: String?){
        
        // run the alert in the main queue because it's a member of UIKit
        dispatch_async(dispatch_get_main_queue(), {()-> Void in
            
            let alert = UIAlertController(title: headTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: { action in
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }) // end image main queue completion handler
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
