//
//  FlickrPictureConvenience.swift
//  TaskOut
//
//  Created by Reagan Wood on 9/28/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation

class FlickrPictureConvenience: NSObject {
    
    let urlForImage = "https://c4.staticflickr.com/9/8412/10245552163_1a7f690bc3_h.jpg"
    

    func getFlickrImage(completionHandler handler: (data: NSData) -> Void){
        
        // start activity indicator
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            
            if let url = NSURL(string: self.urlForImage),let imgData = NSData(contentsOfURL: url){
                handler(data: imgData)
            }// end if
        } // end closure
        
        
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> FlickrPictureConvenience{
        struct Singleton {
            static var sharedInstance = FlickrPictureConvenience()
        }
        return Singleton.sharedInstance
    }
}