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
        
        let photoCreator = FlickrPictureConvenience.sharedInstance()
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        
        photoCreator.getFlickrImage { (data) in
            
            dispatch_async(dispatch_get_main_queue(), {()-> Void in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.imageView.image = UIImage(data: data)
            }) // end image main queue completion handler
        }

    }
    
    @IBAction func ReturnButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
}