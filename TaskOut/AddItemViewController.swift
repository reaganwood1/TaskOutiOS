//
//  AddItemViewController.swift
//  TaskOut
//
//  Created by Reagan Wood on 8/16/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddItemViewController: UIViewController, NSFetchedResultsControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var taskHeaderTextView: UITextView!
    @IBOutlet weak var addTaskButton: UIButton!
    
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
        taskHeaderTextView.delegate = self
        
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if (textView.text == "Enter Task Header") {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == "") {
            textView.text = "Enter Task Header"
        }
    }
    
    @IBAction func addItemButtonClicked(sender: AnyObject) {
        if (taskHeaderTextView.text != "Enter Task Header" && taskHeaderTextView.text != "") {
            let taskHeader = TaskHeader(taskTitle: taskHeaderTextView.text, context: fetchedResultsController!.managedObjectContext)
            do { // saves to the context so network is not hit unnecessarily again
                try self.fetchedResultsController!.managedObjectContext.save()
            }catch {
                print("nothing was saved")
            }
            completeSearch()
            self.dismissViewControllerAnimated(true, completion: { 
                
            })// end completion
        } else {
            displayEmptyAlert("", message: "Please Enter a Task Item Header to Save", actionTitle: "Ok")
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


extension AddItemViewController {
    
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