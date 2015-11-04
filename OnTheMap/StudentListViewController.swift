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
        // reloads the data when adding a new student?
    //    myTableView!.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().myAnnotations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell")! as UITableViewCell
        let myStudent = ParseClient.sharedInstance().myAnnotations[indexPath.row].title
        
        // set the image and text
        cell.imageView?.image = UIImage(named: "Pin")
        cell.textLabel?.text = myStudent
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
 /*       let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
        
*/      let app = UIApplication.sharedApplication()
        if let myURL = ParseClient.sharedInstance().myAnnotations[indexPath.row].subtitle {
            app.openURL(NSURL(string: myURL)!)
        } else {
            print("String URL not found")
        }


    }
    
}
