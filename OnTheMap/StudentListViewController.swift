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

    @IBAction func refreshTableView(sender: AnyObject) {
        ParseClient.sharedInstance().getStudentLocations() { (success, error) in
            if success {
                // Reloads table view with new annotations
                self.myTableView.reloadData()
            } else {
                // Show alert to user
                dispatch_async(dispatch_get_main_queue(), {
                    AlertController.createAlert("Map Error", message: error!.localizedDescription, view: self)
                })
            }
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        UdacityClient.sharedInstance().logout() {
            (success, error) in
            if success {
                // Go back to login view controller
                dispatch_async(dispatch_get_main_queue(), {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
                    self.presentViewController(controller, animated: false, completion: nil)
                })
            } else {
                // Show alert to user
                dispatch_async(dispatch_get_main_queue(), {
                    AlertController.createAlert("Logout Error", message: "Unable to logout", view: self)
                })
            }
        }
    }
    
    // Gets the number of rows for the table view
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().students.count
    }
    
    // Creates the cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell")! as UITableViewCell
        let studentName = ParseClient.sharedInstance().students[indexPath.row].annotation.title
        
        // set the image and text
        cell.imageView?.image = UIImage(named: "Pin")
        cell.textLabel?.text = studentName
        
        return cell
    }
    
    // Opens URL when cell is selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        if let myURL = ParseClient.sharedInstance().students[indexPath.row].annotation.subtitle {
            app.openURL(NSURL(string: myURL)!)
        }
    }
    
}
