//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by Jonathan Chou on 11/3/15.
//  Copyright © 2015 Jonathan Chou. All rights reserved.
//

import Foundation
import UIKit

class StudentListViewController: UITableViewController {
    
    @IBOutlet var myTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func refreshTableView(sender: AnyObject) {
        ParseClient.sharedInstance().getStudentLocations() { (success, error) in
            if success {
                // reloads table view
                dispatch_async(dispatch_get_main_queue(), {
                    self.myTableView.reloadData()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Map Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().myAnnotations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell")! as UITableViewCell
        let studentName = ParseClient.sharedInstance().myAnnotations[indexPath.row].title
        
        // set the image and text
        cell.imageView?.image = UIImage(named: "Pin")
        cell.textLabel?.text = studentName
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: check url syntax?
        let app = UIApplication.sharedApplication()
        if let myURL = ParseClient.sharedInstance().myAnnotations[indexPath.row].subtitle {
            app.openURL(NSURL(string: myURL)!)
        } else {
            print("String URL not found")
        }


    }
    
}
