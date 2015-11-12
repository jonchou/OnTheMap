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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let annotation = MKPointAnnotation()
    
    @IBAction func leaveView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func geoCodeLocation(sender: AnyObject) {
        let geoCoder =  CLGeocoder()
        activityIndicator.startAnimating()
        
        // Geocodes location to a longitude and latitude that can be found on the map
        geoCoder.geocodeAddressString(studentLocation.text!) {
            (placemarks, error) in
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.annotation.coordinate = coordinates
                self.mapView.addAnnotation(self.annotation)
                // zoom in on region
                let mySpan = MKCoordinateSpanMake(0.1, 0.1)
                let myRegion = MKCoordinateRegionMake(coordinates, mySpan)
                self.mapView.region = myRegion
                // ConfigureUI
                self.configureUI()
            } else {
                // Show alert to user
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.stopAnimating()
                    AlertController.createAlert("Geocode Error", message: error!.localizedDescription, view: self)
                })
            }

        }
    }
    
    @IBAction func submitLocation(sender: AnyObject) {
        // Initialize the JSON body that will be used in the request
        let jsonBody : [String: AnyObject] = [
            "uniqueKey": UdacityClient.sharedInstance().userID!,
            "firstName": UdacityClient.sharedInstance().firstName!,
            "lastName": UdacityClient.sharedInstance().lastName!,
            "mapString": studentLocation.text!,
            "mediaURL": urlTextField.text!,
            "latitude": annotation.coordinate.latitude,
            "longitude": annotation.coordinate.longitude
        ]
        
        ParseClient.sharedInstance().postStudentLocation(jsonBody) {
            (success, error) in
            if success {
                // Go back to the tab bar view controller
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                // Show alert to user
                dispatch_async(dispatch_get_main_queue(), {
                    AlertController.createAlert("Post Error", message: error!.localizedDescription, view: self)
                })
            }
        }
    }
    
    // Configures the UI so we don't need another view controller
    func configureUI() {
        mapView.hidden = false
        studentLocation.hidden = true
        topView.hidden = true
        bottomView.hidden = true
        cancelButton.tintColor = UIColor.whiteColor()
        submitButton.hidden = false
        urlTextField.hidden = false
        activityIndicator.stopAnimating()
    }

}
