//
//  AlertController.swift
//  OnTheMap
//
//  Created by Jonathan Chou on 11/11/15.
//  Copyright © 2015 Jonathan Chou. All rights reserved.
//

import Foundation
import UIKit

public class AlertController {
    class func createAlert(title: String, message: String, view: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        view.presentViewController(alert, animated: true, completion: nil)
    }
}
