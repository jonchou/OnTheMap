//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Jonathan Chou on 11/10/15.
//  Copyright © 2015 Jonathan Chou. All rights reserved.
//

import Foundation
import MapKit

struct StudentInformation {
    var latitude: Double
    var longitude: Double
    var coordinate: CLLocationCoordinate2D
    var firstName: String
    var lastName: String
    var mediaURL: String
    var annotation: MKPointAnnotation
    
    init(dictionary: [String:AnyObject]) {
        latitude = CLLocationDegrees(dictionary["latitude"] as! Double)
        longitude = CLLocationDegrees(dictionary["longitude"] as! Double)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(firstName) \(lastName)"
        annotation.subtitle = mediaURL
    }
    
    static func getStudentInformationData(results: [[String : AnyObject]]) {
        DataModel.sharedInstance().students = [StudentInformation]()
        DataModel.sharedInstance().myAnnotations = [MKPointAnnotation]()
        for student in results {
            let myStudent = StudentInformation(dictionary: student)
            DataModel.sharedInstance().students.append(StudentInformation(dictionary: student))
            DataModel.sharedInstance().myAnnotations.append(myStudent.annotation)

        }
    }
}

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