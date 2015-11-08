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
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                self.mapView.addAnnotation(annotation)
                // zoom in on region
                let mySpan = MKCoordinateSpanMake(0.5, 0.5)
                let myRegion = MKCoordinateRegionMake(coordinates, mySpan)
                self.mapView.region = myRegion
            }
        })
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
