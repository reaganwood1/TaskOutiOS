//
//  TaskHeader+CoreDataProperties.swift
//  TaskOut
//
//  Created by Reagan Wood on 8/16/16.
//  Copyright © 2016 RW Software. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TaskHeader {

    @NSManaged var taskTitle: String?
    @NSManaged var taskType: NSNumber?
    @NSManaged var taskItem: NSSet?

}
