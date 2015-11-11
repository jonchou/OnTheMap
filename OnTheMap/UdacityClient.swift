//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Jonathan Chou on 10/30/15.
//  Copyright © 2015 Jonathan Chou. All rights reserved.
//

import Foundation

class UdacityClient {
    
    var session: NSURLSession
    var sessionID : String? = nil
    var userID : String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    
    init() {
        session = NSURLSession.sharedSession()
    }
    
    func taskForGETMethod(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Build the URL and configure the request
        let urlString = Constants.baseURLSecureString + method
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
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
                    let newError = NSError(domain: "taskForGetMethod statusCode", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to get user data"])
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
            
            // subset response data
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            // Parse the data and use the data (happens in completion handler)
            UdacityClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
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
        request.addValue("application/json", forHTTPHeaderField: "Accept")
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
                    let newError = NSError(domain: "taskForPostMethod statusCode", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid email or password"])
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
            
             // subset response data
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
        
            // Parse the data and use the data (happens in completion handler)
            UdacityClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
        }
        
        // Start the request
        task.resume()
        return task
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}
