//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Jonathan Chou on 10/30/15.
//  Copyright © 2015 Jonathan Chou. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func authenticateWithUserPass (username: String?, password: String?, completionHandler: (success: Bool, error: NSError?) -> Void) {
        createSession(username, password: password) {
            (success, error) in
            if success {
                self.getUserData(completionHandler)
            } else {
                completionHandler(success: success, error: error)
            }
        }
    }
    
    func createError(domain: String, errorMessage: String, completionHandler: (success: Bool, error: NSError) -> Void) {
        let newError = NSError(domain: domain, code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        completionHandler(success: false, error: newError)
    }
    
    func createSession(username: String?, password: String?, completionHandler: (success: Bool, error: NSError?) -> Void) {
        // Set parameters
        let jsonBody : [String: AnyObject] = [
            "udacity": [
                "username": username!,
                "password": password!
            ]
        ]
        taskForPOSTMethod(Methods.Session, jsonBody: jsonBody) {
            (result, error) in
            if let error = error {
                completionHandler(success: false, error: error)
                return
            }
            if let account = result["account"] as? [String:AnyObject] {
                if let userKey = account["key"] as? String {
                    self.userID = userKey
                    if let session = result["session"] as? [String:AnyObject] {
                        if let sessionID = session["id"] as? String {
                            self.sessionID = sessionID
                            completionHandler(success: true, error: nil)
                        } else {
                            self.createError("createSession", errorMessage: "Failed to get SessionID", completionHandler: completionHandler)
                        }
                    } else {
                        self.createError("createSession", errorMessage: "Failed to get session", completionHandler: completionHandler)
                    }
                } else {
                    self.createError("createSession", errorMessage: "Failed to get user key", completionHandler: completionHandler)
                }
            } else {
                self.createError("createSession", errorMessage: "Failed to get account", completionHandler: completionHandler)
            }
        }
    }
    
    func getUserData(completionHandler: (success: Bool, error: NSError?) -> Void) {
        var mutableMethod : String = Methods.UserData
        mutableMethod = UdacityClient.subtituteKeyInMethod(mutableMethod, key: UdacityClient.URLKeys.UserID, value: String(UdacityClient.sharedInstance().userID!))!
        
        taskForGETMethod(mutableMethod) {
            (result, error) in
            if let error = error {
                completionHandler(success: false, error: error)
                return
            }
            if let user = result["user"] as? [String:AnyObject] {
                if let firstName = user["first_name"] as? String {
                    self.firstName = firstName
                    if let lastName = user["last_name"] as? String {
                        self.lastName = lastName
                        completionHandler(success: true, error: nil)
                    } else {
                        self.createError("getUserData", errorMessage: "Failed to get last name", completionHandler: completionHandler)
                    }
                } else {
                    self.createError("getUserData", errorMessage: "Failed to get first name", completionHandler: completionHandler)
                }
            } else {
                self.createError("getUserData", errorMessage: "Failed to get user", completionHandler: completionHandler)
            }
        }
    }

}