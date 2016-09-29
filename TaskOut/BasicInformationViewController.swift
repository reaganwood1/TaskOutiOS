//
//  BasicInformationViewController.swift
//  TaskOut
//
//  Created by Reagan Wood on 9/28/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation
import UIKit

class BasicInformationViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var returnButton: UIButton!
    
    override func viewDidLoad() {

        let photoCreator = FlickrClient.sharedInstance()
        if (Reachability.isConnectedToNetwork()) {
            activityIndicator.startAnimating()
            activityIndicator.hidden = false
            
            // get photo to display in imageView to display in the view
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { () -> Void in
                photoCreator.retrievePhotoFromFlickr("Mountain") { (success, photoURLs, error) in
                    if (success == true) {
                        photoCreator.getPhotoImage(photoURLs[0], completionHandler: { (image, success) in
                            
                            if (success == true) { // if success, display the photo image
                                dispatch_async(dispatch_get_main_queue(), {()-> Void in
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.hidden = true
                                    self.imageView.image = UIImage(data: image!)
                                }) // end image main queue completion handler
                            } else { // handle network failure
                                self.displayEmptyAlert("", message: "The photo was not retrieved correctly from the network", actionTitle: "Ok")
                            }
                            
                        })
                    } else { // handle network failure
                         self.displayEmptyAlert("", message: "The photo was not retrieved correctly from the network", actionTitle: "Ok")
                    }
                    
                }
                
                
            } // end closure
        } else {
            displayEmptyAlert("", message: "It appears that you aren't connected to the network.", actionTitle: "Ok")
            activityIndicator.hidden = true
            activityIndicator.stopAnimating()
        }
    }
    
    
    // function for handling alerts of different types
    func displayEmptyAlert(headTitle: String?, message: String?, actionTitle: String?){
        
        // run the alert in the main queue because it's a member of UIKit
        dispatch_async(dispatch_get_main_queue(), {()-> Void in
            
            let alert = UIAlertController(title: headTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: { action in
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }) // end image main queue completion handler
    }

    // dismiss the view on return button being pressed
    @IBAction func ReturnButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
}