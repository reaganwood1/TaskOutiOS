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

class AddItemViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var TaskHeader: UITextView!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
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
    
    @IBAction func addItemButtonClicked(sender: AnyObject) {
        if (TaskHeader.text != "Enter Task Header" || TaskHeader.text != "") {
            
        } // end if
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