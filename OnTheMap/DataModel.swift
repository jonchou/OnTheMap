//
//  DataModel.swift
//  OnTheMap
//
//  Created by Jonathan Chou on 11/12/15.
//  Copyright © 2015 Jonathan Chou. All rights reserved.
//

import Foundation
import MapKit

class DataModel {
    var students: [StudentInformation]
    var myAnnotations: [MKPointAnnotation]

    init() {
        students = [StudentInformation]()
        myAnnotations = [MKPointAnnotation]()
    }
    
    class func sharedInstance() -> DataModel {
        struct Singleton {
            static var sharedInstance = DataModel()
        }
        return Singleton.sharedInstance
    }
}