//
//  ViewController.swift
//  Complete
//

//  Copyright (c) 2015 Jay Ang. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var taskTable: UITableView!
    @IBOutlet var addBarButtonItem: UIBarButtonItem!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var tasks = [Tasks]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "ToDo Tasks"
        
//        if let managedObjectContext = self.managedObjectContext {
//            
//            var tasks = [("Cook","Make a pasta"), ("Learn a new language","Swift"), ("Workout","Run for 30 minutes"), ("Read", "Any awesome books!"), ("Practice Guitar", "To the tune of Ed Sheeran's Don't")]
//            
//            for (taskName, taskDescription) in tasks {
//                
//                Tasks.createNewTask(managedObjectContext, name: taskName, description: taskDescription)
//            }
//        }
        
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
    
    //MARK: Table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskCell") as! UITableViewCell
        
        let tasks = self.tasks[indexPath.row]
        
        cell.textLabel?.text = tasks.taskName
        return cell
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let taskToBeDeleted = self.tasks[indexPath.row]
            self.managedObjectContext?.deleteObject(taskToBeDeleted)
            self.retrieveTasks()
            self.taskTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            savingToCoreData()
            
        }
        
    }
    
    //MARK: Add Bar Button
    @IBAction func onAddBarButtonItem(sender: AnyObject) {
        
        var instructionTitle = UIAlertController(title: "Add Task", message: "Enter your Task title", preferredStyle: UIAlertControllerStyle.Alert)
        
        var instructionTextField: UITextField?
        instructionTitle.addTextFieldWithConfigurationHandler { (textField) -> Void in
            instructionTextField = textField
            instructionTextField?.placeholder = "Task Title"
        }
        
        var instructionAction = UIAlertAction(title: "Create Task", style: UIAlertActionStyle.Default) { (UIAlertAction action) -> Void in
            
            if let textFieldPrompt = instructionTextField {
                self.saveNewlyCreatedTask(textFieldPrompt.text)
            }

        }
        
        instructionTitle.addAction(instructionAction)
        
        self.presentViewController(instructionTitle, animated: true, completion: nil)
        
    }
    
    func saveNewlyCreatedTask(title: String) {
        
        var newTask = Tasks.createNewTask(self.managedObjectContext!, name: title, description: "")
        
        self.retrieveTasks()
        
        if let newlyCreatedTask = find(self.tasks, newTask) {
            
            let newlycreatedTaskIndexPath = NSIndexPath(forRow: newlyCreatedTask, inSection: 0)
            
            self.taskTable.insertRowsAtIndexPaths([newlycreatedTaskIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            savingToCoreData()
        }
    }
    
    //MARK: saving to core data
    func savingToCoreData() {
        
        var error: NSError?
        
        if managedObjectContext!.save(&error) {
            println(error?.localizedDescription)
        }
    }
}

