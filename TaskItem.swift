//
//  TaskItem.swift
//  TaskOut
//
//  Created by Reagan Wood on 8/16/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation
import CoreData


class TaskItem: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    convenience init(title: String, context : NSManagedObjectContext){
        
        // An EntityDescription is an object that has access to all
        // the information you provided in the Entity part of the model
        // you need it to create an instance of this class.
        if let ent = NSEntityDescription.entityForName("TaskItem",
                                                       inManagedObjectContext: context){
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.title = title
        }else{
            fatalError("Unable to find Entity name!")
        }
        
    }
}
