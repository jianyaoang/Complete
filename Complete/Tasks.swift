//
//  Tasks.swift
//  Complete
//
//  Created by VLT Labs on 6/20/15.
//  Copyright (c) 2015 Jay Ang. All rights reserved.
//

import Foundation
import CoreData

class Tasks: NSManagedObject {

    @NSManaged var taskName: String
    @NSManaged var taskDescription: String

    class func createNewTask(moc: NSManagedObjectContext, name: String, description: String) -> Tasks {
        
        let newTask = NSEntityDescription.insertNewObjectForEntityForName("Tasks", inManagedObjectContext: moc) as! Tasks
        
        newTask.taskName = name
        newTask.taskDescription = description
        
        return newTask
    }
    
    
    
}
