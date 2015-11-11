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
    
    func getStudentLocations(completionHandler: (success: Bool, error: String?) -> Void) {
        
        // Initialize parameters
        let parameters = ["limit": 100, "order": "-updatedAt"]
        
        taskForGETMethod(Methods.StudentLocation, parameters: parameters) {
            (result, error) in
            if let error = error {
                print(error)
                completionHandler(success: false, error: "Failed to get student location")
                // TODO: Alertview?
            } else {
                for dictionary in result["results"] as! [[String:AnyObject]] {
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                    let long = CLLocationDegrees(dictionary["longitude"] as! Double)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let first = dictionary["firstName"] as! String
                    let last = dictionary["lastName"] as! String
                    let mediaURL = dictionary["mediaURL"] as! String
                    
                    // Here we create the annotation and set its coordinate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    self.myAnnotations.append(annotation)
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