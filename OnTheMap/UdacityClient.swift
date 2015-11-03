//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Jonathan Chou on 10/30/15.
//  Copyright © 2015 Jonathan Chou. All rights reserved.
//

import Foundation

class UdacityClient {
    
    /* Shared session */
    var session: NSURLSession
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : Int? = nil
    
    init() {
        session = NSURLSession.sharedSession()
    }
    
    func createSession(username: String?, password: String?, completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
        /* 1. Set the parameters */
        let jsonBody : [String: AnyObject] = [
            "udacity": [
                "username": username!,
                "password": password!
            ]
        ]
        /* 2. Build the URL */
        let urlString = "https://www.udacity.com/api/session"
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }

        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard (error == nil) else {
                print("Login Failed (Session).")
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
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
           // print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            // parse for session ID
            UdacityClient.parseJSONWithCompletionHandler(newData) { (result, error) in
                if let session = result["session"] as? [String:AnyObject] {
                    if let sessionID = session["id"] as? String {
                        completionHandler(success: true, sessionID: sessionID, errorString: nil)
                    } else {
                        completionHandler(success: false, sessionID: nil, errorString: "Failed Session ID")
                    }
                } else {
                    completionHandler(success: false, sessionID: nil, errorString: "Failed Session")
                }
            }
        }
        
        task.resume()
    }
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}
