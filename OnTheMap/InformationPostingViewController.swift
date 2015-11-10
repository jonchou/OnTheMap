//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Jonathan Chou on 11/7/15.
//  Copyright © 2015 Jonathan Chou. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var studentLocation: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var urlTextField: UITextField!
    
    let annotation = MKPointAnnotation()
    
    @IBAction func leaveView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func geoCodeLocation(sender: AnyObject) {
        let geoCoder =  CLGeocoder()
        
        // ConfigureUI
        configureUI()
        geoCoder.geocodeAddressString(studentLocation.text!, completionHandler:
            {(placemarks, error) -> Void in
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.annotation.coordinate = coordinates
                self.mapView.addAnnotation(self.annotation)
                // zoom in on region
                let mySpan = MKCoordinateSpanMake(0.1, 0.1)
                let myRegion = MKCoordinateRegionMake(coordinates, mySpan)
                self.mapView.region = myRegion
            } else {
                    print("Couldn't assign placemark")
            }
        })
    }
    
    @IBAction func submitLocation(sender: AnyObject) {
        let jsonBody : [String: AnyObject] = [
            "uniqueKey": UdacityClient.sharedInstance().userID!,
            "firstName": UdacityClient.sharedInstance().firstName!,
            "lastName": UdacityClient.sharedInstance().lastName!,
            "mapString": studentLocation.text!,
            "mediaURL": urlTextField.text!,
            "latitude": annotation.coordinate.latitude,
            "longitude": annotation.coordinate.longitude
        ]
        
        // FOR OVERWRITING SAME STUDENT POST
        // if query objectID == nil
        // poststudentlocation
        // else
        // alertview for updating location ??
        
        ParseClient.sharedInstance().postStudentLocation(jsonBody) {
            (success, error) in
            if success {
                print("success in posting student information")
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print("failed to submit location")
                // TODO: alert view for error to submitting location
            }
        }
    }
    
    func configureUI() {
        //TODO: configure hiding UI
        mapView.hidden = false
        studentLocation.hidden = true
        topView.hidden = true
        bottomView.hidden = true
        cancelButton.tintColor = UIColor.whiteColor()
        submitButton.hidden = false
        urlTextField.hidden = false
        
    }
    

}
