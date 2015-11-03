//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Jonathan Chou on 11/2/15.
//  Copyright © 2015 Jonathan Chou. All rights reserved.
//

import Foundation
import MapKit

class ParseClient {
    
    static let parseID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let restAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    /* Shared session */
    var session: NSURLSession
    
    init() {
        session = NSURLSession.sharedSession()
    }
    
    // redundant function?
    func setupMap(completionHandler: (success: Bool, annotations: [MKPointAnnotation]?, error: String?) -> Void) {
        getStudentLocations() { (success, annotations, error) in
            if success {
                completionHandler(success: true, annotations: annotations, error: nil)
            } else {
                completionHandler(success: false, annotations: nil, error: error)

            }
        }
    }
    
    func getStudentLocations(completionHandler: (success: Bool, annotations: [MKPointAnnotation], error: String?) -> Void) {
        var annotations = [MKPointAnnotation]()
        
        // Initialize parameters
        let parameters = ["limit": 100]
        
        // Build the URL
        let urlString = "https://api.parse.com/1/classes/StudentLocation" + ParseClient.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        
        // Make the request
        let request = NSMutableURLRequest(URL: url)
        request.addValue(ParseClient.parseID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard (error == nil) else {
                print("Map Failed (Student Locations).")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            UdacityClient.parseJSONWithCompletionHandler(data) { (result, error) in
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
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                completionHandler(success: true, annotations: annotations, error: nil)
            }
        }
        task.resume()
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        var urlVars = [String]()
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}