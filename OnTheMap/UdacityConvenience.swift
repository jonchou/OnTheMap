//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Jonathan Chou on 10/30/15.
//  Copyright © 2015 Jonathan Chou. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func authenticateWithUserPass (username: String?, password: String?, completionHandler: (success: Bool, errorString: String?) -> Void) {
        createSession(username, password: password) {
            (success, error) in
            if success {
                self.getUserData(completionHandler)
            } else {
                completionHandler(success: success, errorString: error)
            }
        }
    }
    
    func createSession(username: String?, password: String?, completionHandler: (success: Bool, errorString: String?) -> Void) {
        // Set parameters
        let jsonBody : [String: AnyObject] = [
            "udacity": [
                "username": username!,
                "password": password!
            ]
        ]
        taskForPOSTMethod(Methods.Session, jsonBody: jsonBody) {
            (result, error) in
            if let account = result["account"] as? [String:AnyObject] {
                if let userKey = account["key"] as? String {
                    self.userID = userKey
                    if let session = result["session"] as? [String:AnyObject] {
                        if let sessionID = session["id"] as? String {
                            self.sessionID = sessionID
                            completionHandler(success: true, errorString: nil)
                        } else {
                            completionHandler(success: false, errorString: "Failed to get session ID")
                        }
                    } else {
                        completionHandler(success: false, errorString: "Failed to get session")
                    }
                } else {
                    completionHandler(success: false, errorString: "Failed to get user key")
                }
            } else {
                completionHandler(success: false, errorString: "Failed to get account")
            }
        }
    }
    
    func getUserData(completionHandler: (success: Bool, errorString: String?) -> Void) {
        var mutableMethod : String = Methods.UserData
        mutableMethod = UdacityClient.subtituteKeyInMethod(mutableMethod, key: UdacityClient.URLKeys.UserID, value: String(UdacityClient.sharedInstance().userID!))!
        
        taskForGETMethod(mutableMethod) {
            (result, error) in
            if let user = result["user"] as? [String:AnyObject] {
                if let firstName = user["first_name"] as? String {
                    self.firstName = firstName
                    if let lastName = user["last_name"] as? String {
                        self.lastName = lastName
                        completionHandler(success: true, errorString: nil)
                    } else {
                        completionHandler(success: false, errorString: "Failed getting last name")
                    }
                } else {
                    completionHandler(success: false, errorString: "Failed getting first name")
                }
            } else {
                completionHandler(success: false, errorString: "Failed getting user")
            }
        }
    }

}