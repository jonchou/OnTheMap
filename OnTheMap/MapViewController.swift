//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Jonathan Chou on 10/30/15.
//  Copyright © 2015 Jonathan Chou. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ParseClient.sharedInstance().getStudentLocations() {
            (success, error) in
            if success {
                // Add annotations to the map
                dispatch_async(dispatch_get_main_queue(), {
                    self.mapView.addAnnotations(ParseClient.sharedInstance().myAnnotations)
                })
            } else {
                // Show alert to user
                dispatch_async(dispatch_get_main_queue(), {
                    AlertController.createAlert("Map Error", message: error!.localizedDescription, view: self)
                })
            }
        }
    }
    @IBAction func logout(sender: AnyObject) {
        UdacityClient.sharedInstance().logout() {
            (success, error) in
            if success {
                // Go back to the login view controller
                dispatch_async(dispatch_get_main_queue(), {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
                    self.presentViewController(controller, animated: false, completion: nil)
                })
            } else {
                // Show alert to user
                dispatch_async(dispatch_get_main_queue(), {
                    AlertController.createAlert("Logout Error", message: "Unable to logout", view: self)
                })
            }
        }
    }
    
    @IBAction func reloadMapData(sender: AnyObject) {
        // Remove old annotations on map
        let oldMapAnnotations = ParseClient.sharedInstance().myAnnotations
        self.mapView.removeAnnotations(oldMapAnnotations)
        
        ParseClient.sharedInstance().getStudentLocations() { (success, error) in
            if success {
                // Add new annotations to map
                dispatch_async(dispatch_get_main_queue(), {
                    self.mapView.addAnnotations(ParseClient.sharedInstance().myAnnotations)
                })
            } else {
                // Show alert to user
                dispatch_async(dispatch_get_main_queue(), {
                    AlertController.createAlert("Map Error", message: error!.localizedDescription, view: self)
                })
            }
        }
        
    }
    // Here we create a view with a "right callout accessory view"
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // Opens browser when annotation is tapped
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
}

