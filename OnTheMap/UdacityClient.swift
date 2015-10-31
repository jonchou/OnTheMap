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
    
    func createSession(username: String?, password: String?, completionHandler: (success: Bool, sessionID: String, errorString: String?) -> Void) {
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
        // let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard (error == nil) else {
                dispatch_async(dispatch_get_main_queue()) {
                    print("Login Failed (Session).")
                }
                print("There was an error with your request: \(error)")
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
   //         UdacityClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler(result: newData, error: nil))

  /*          if let sessionID = newData["session"] as? String {
                completionHandler(success: true, sessionID: sessionID!, errorString: nil)
            } else {
                completionHandler(success: false, sessionID: nil, errorString: "Failed login")
            }
  */
        }
        task.resume()
        
/*        if let requestToken = JSONResult[TMDBClient.JSONResponseKeys.RequestToken] as? String {
            completionHandler(success: true, requestToken: requestToken, errorString: nil)
        } else {
            print("Could not find \(TMDBClient.JSONResponseKeys.RequestToken) in \(JSONResult)")
            completionHandler(success: false, requestToken: nil, errorString: "Login Failed (Request Token).")
        }
   */
        completionHandler(success: true, sessionID: "hello", errorString: nil)
    }
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}
