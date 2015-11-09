//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Jonathan Chou on 11/8/15.
//  Copyright © 2015 Jonathan Chou. All rights reserved.
//

import Foundation

extension UdacityClient {
    struct Constants {
        static let baseURLSecureString = "https://www.udacity.com/api/"
    }
    
    struct Methods {
        static let Session = "session"
        static let UserData = "users/{id}"
    }
    
    struct URLKeys {
        static let UserID = "id"
    }
}
    