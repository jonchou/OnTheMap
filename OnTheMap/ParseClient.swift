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
    var session: NSURLSession
    var myAnnotations: [MKPointAnnotation]
    var studentInformation: [StudentInformation]
    
    init() {
        session = NSURLSession.sharedSession()
        myAnnotations = [MKPointAnnotation]()
        studentInformation = [StudentInformation]()
    }
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        // Build the URL and configure the request
        let urlString = Constants.baseURLSecureString + method + ParseClient.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        request.addValue(ParseClient.Constants.parseID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        // Make the request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                completionHandler(result: nil, error: error)
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let _ = response as? NSHTTPURLResponse {
                    let newError = NSError(domain: "taskForGetMethod", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to get location"])
                    completionHandler(result: nil, error: newError)
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                let newError = NSError(domain: "taskForGetMethod data", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data was returned by the request!"])
                completionHandler(result: nil, error: newError)
                return
            }
            
            // Parse the data and use the data (happens in completion handler)
            UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        // Start the request
        task.resume()
        return task
    }

    func taskForPOSTMethod(method: String, jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Build the URL and configure the request
        let urlString = Constants.baseURLSecureString + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(ParseClient.Constants.parseID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        // Make the request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            // GUARD: Was there an error?
            guard (error == nil) else {
                completionHandler(result: nil, error: error)
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let _ = response as? NSHTTPURLResponse {
                    let newError = NSError(domain: "postStudentLocation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to post location"])
                    completionHandler(result: nil, error: newError)
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                let newError = NSError(domain: "taskForPostMethod data", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data was returned by the request!"])
                completionHandler(result: nil, error: newError)
                return
            }
            
            // Parse the data and use the data (happens in completion handler)
            UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        // Start the request
        task.resume()
        return task
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