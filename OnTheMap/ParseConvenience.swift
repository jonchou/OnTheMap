//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Jonathan Chou on 11/9/15.
//  Copyright © 2015 Jonathan Chou. All rights reserved.
//

import Foundation
import MapKit

extension ParseClient {
    
    func getStudentLocations(completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        // Initialize parameters
        let parameters = ["limit": 100, "order": "-updatedAt"]
        
        taskForGETMethod(Methods.StudentLocation, parameters: parameters) {
            (result, error) in
            if let error = error {
                completionHandler(success: false, error: error)
                return
            } else {
                // clean the array of annotations to initialize a new one when reloading data
                self.myAnnotations = [MKPointAnnotation]()
                // Initialize all student information into an array of the struct StudentInformation
                for dictionary in result["results"] as! [[String:AnyObject]] {
                    let student = StudentInformation.init(dictionary: dictionary)
                    self.myAnnotations.append(student.annotation)
                    self.studentInformation.append(student)
                }
                completionHandler(success: true, error: nil)
            }
        }
    }
    
    func postStudentLocation(jsonBody: [String:AnyObject],completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        taskForPOSTMethod(Methods.StudentLocation, jsonBody: jsonBody) {
            (result, error) in
            if let error = error {
                completionHandler(success: false, error: error)
            } else {
                completionHandler(success: true, error: nil)
            }
        }
    }
}