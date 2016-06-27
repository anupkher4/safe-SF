//
//  ViewController.swift
//  SafeSF
//
//  Created by Anup Kher on 6/25/16.
//  Copyright © 2016 Globant. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class IncidentMapViewController: UIViewController {
    
    // San Francisco map coordinates
    let initialLat = 37.783333
    let initialLong = -122.416667

    @IBOutlet var incidentMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        incidentMapView.delegate = self
        
        showOnMap(latitude: initialLat, longitude: initialLong, mapToShow: incidentMapView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension IncidentMapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MKMapView Delegate delegate methods
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // If the annotation is the user location, just return nil
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        // Handling custom annotations
        if annotation.isKindOfClass(IncidentAnnotation) {
            // Tring to dequeue an existing pin view first
            var pinView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier("IncidentPinAnnotationView") as? MKPinAnnotationView
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "IncidentPinAnnotationView")
                pinView?.pinTintColor = UIColor.yellowColor()
                pinView?.animatesDrop = true
                pinView?.canShowCallout = true
                
                // Customizing the callout by adding accessory views
                
                // Adding a detail disclosure button to the callout on the right
                let rightButton: UIButton = UIButton(type: .DetailDisclosure)
                rightButton.addTarget(nil, action: nil, forControlEvents: .TouchUpInside)
                pinView?.rightCalloutAccessoryView = rightButton
                
                // Adding a custom image to the callout on the left
                let calloutCustomImage: UIImageView = UIImageView(image: nil)
                pinView?.leftCalloutAccessoryView = calloutCustomImage
            } else {
                pinView?.annotation = annotation
            }
            
            return pinView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Show detail view for right accessory button
        
    }
    
    // Map helper functions
    func showOnMap(latitude lat: CLLocationDegrees?, longitude long: CLLocationDegrees?, mapToShow map: MKMapView?) {
        guard let mapView = map else {
            print("Passed in map object is nil")
            return
        }
        guard let mapLat = lat, let mapLong = long else {
            print("Invalid coordinates for map")
            return
        }
        
        let mapCenter = CLLocationCoordinate2D(latitude: mapLat, longitude: mapLong)
        
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.09)
        
        mapView.region = MKCoordinateRegion(center: mapCenter, span: mapSpan)
    }
    
    // CLLocationManagerDelegate delegate methods
}

