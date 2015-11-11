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
                // reloads table view
                self.myTableView.reloadData()
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Map Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        UdacityClient.sharedInstance().logout() {
            (success, error) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    // go back to initial VC
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
                    self.presentViewController(controller, animated: false, completion: nil)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Logout Error", message: "Unable to logout", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().students.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell")! as UITableViewCell
        let studentName = ParseClient.sharedInstance().students[indexPath.row].annotation.title
        
        // set the image and text
        cell.imageView?.image = UIImage(named: "Pin")
        cell.textLabel?.text = studentName
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: check url syntax?
        let app = UIApplication.sharedApplication()
        if let myURL = ParseClient.sharedInstance().students[indexPath.row].annotation.subtitle {
            app.openURL(NSURL(string: myURL)!)
        } else {
            print("String URL not found")
        }


    }
    
}
