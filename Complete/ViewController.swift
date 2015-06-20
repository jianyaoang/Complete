//
//  ViewController.swift
//  Complete
//

//  Copyright (c) 2015 Jay Ang. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()

        let newTask = NSEntityDescription.insertNewObjectForEntityForName("Tasks", inManagedObjectContext: managedObjectContext!) as! Tasks
        newTask.taskName = "House of Cards"
        newTask.taskDescription = "Complete remaining episodes of House Of Cards"
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let fetchRequest = NSFetchRequest(entityName: "Tasks")
        
        if let fetchRequestResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Tasks] {
            
            let alert = UIAlertController(title: fetchRequestResults[0].taskName, message: fetchRequestResults[0].taskDescription, preferredStyle: UIAlertControllerStyle.Alert)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }


}

