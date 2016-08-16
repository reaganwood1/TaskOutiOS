//
//  TaskItem+CoreDataProperties.swift
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

extension TaskItem {

    @NSManaged var archived: NSNumber?
    @NSManaged var title: String?
    @NSManaged var descriptionText: String?
    @NSManaged var taskImage: NSData?
    @NSManaged var taskTime: NSNumber?
    @NSManaged var taskType: NSNumber?
    @NSManaged var taskDate: NSDate?
    @NSManaged var taskHeader: TaskHeader?

}
