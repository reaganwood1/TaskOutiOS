//
//  TaskHeader.swift
//  TaskOut
//
//  Created by Reagan Wood on 8/16/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation
import CoreData


class TaskHeader: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    convenience init(taskTitle: String,  context : NSManagedObjectContext){
        
        // An EntityDescription is an object that has access to all
        // the information you provided in the Entity part of the model
        // you need it to create an instance of this class.
        if let ent = NSEntityDescription.entityForName("TaskHeader",
                                                       inManagedObjectContext: context){
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.taskTitle = taskTitle
        }else{
            fatalError("Unable to find Entity name!")
        }
        
    }
    
    // source / inspiration - Jarrod Parkes, a Udacity instructor: https://github.com/jarrodparkes/ios-virtual-tourist/blob/master/VirtualTourist/Photo.swift
    func deletePhotos(context: NSManagedObjectContext) {
        if let items = taskItem {
            for item in items {
                context.deleteObject(item as! NSManagedObject)
            }
        }
    } // end function
}
