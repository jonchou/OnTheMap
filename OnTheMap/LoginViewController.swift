//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jonathan Chou on 10/30/15.
//  Copyright © 2015 Jonathan Chou. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    var session: NSURLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
        
        /* Configure the UI */
    //    self.configureUI()
    }

    @IBAction func loginButtonTouch(sender: AnyObject) {
        /*TMDBClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
            if success {
                self.completeLogin()
            } else {
                self.displayError(errorString)
            }
        }
        */
        completeLogin()
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController")// as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
}