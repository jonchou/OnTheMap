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
                if let results = result.valueForKey("results") as? [[String : AnyObject]] {
                    DataModel.sharedInstance().students = StudentInformation.studentInformationFromResults(results)
                    DataModel.sharedInstance().myAnnotations = StudentInformation.getMapAnnotationsFromResults(results)
                    completionHandler(success: true, error: nil)
                } else {
                    UdacityClient.sharedInstance().createError("getStudentLocations", errorMessage: "Failed to get results", completionHandler: completionHandler)
                }
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