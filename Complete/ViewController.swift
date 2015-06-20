//
//  ViewController.swift
//  Complete
//

//  Copyright (c) 2015 Jay Ang. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var tasks = [Tasks]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let managedObjectContext = self.managedObjectContext {
            
            var tasks = [("Cook","Make a pasta"), ("Learn a new language","Swift"), ("Workout","Run for 30 minutes"), ("Read", "Any awesome books!"), ("Practice Guitar", "To the tune of Ed Sheeran's Don't")]
            
            for (taskName, taskDescription) in tasks {
                
                Tasks.createNewTask(managedObjectContext, name: taskName, description: taskDescription)
            }
        }
        
        retrieveTasks()
        
    }

    func retrieveTasks() {
        
        let fetchRequest = NSFetchRequest(entityName: "Tasks")
        
        let sortDesciptorTasks = NSSortDescriptor(key: "taskName", ascending: true)
        fetchRequest.sortDescriptors = [sortDesciptorTasks]
        
        
        if let fetchRequestResults = self.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [Tasks] {
            
            self.tasks = fetchRequestResults
        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskCell") as! UITableViewCell
        
        let tasks = self.tasks[indexPath.row]
        
        cell.textLabel?.text = tasks.taskName
        return cell
        
    }
}

