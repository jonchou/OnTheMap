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

    
}