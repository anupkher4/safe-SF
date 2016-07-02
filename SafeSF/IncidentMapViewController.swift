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
    let initialLocation = CLLocation(latitude: 37.783333, longitude: -122.416667)
    
    // ApiManager instance
    let apiManager = APIManager()

    // Incident count per district
    var districtIncidentCounts = [String : Int]()
    
    @IBOutlet var incidentMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        incidentMapView.delegate = self
        
        showOnMap(location: initialLocation, mapToShow: incidentMapView)
        
        apiManager.getIncidentReports({ incidents in
            guard let allIncidents = incidents else {
                print("No incidents to show")
                return
            }
            print("No of incidents: \(allIncidents.count)")
            for incident in allIncidents {
                let district = incident.pddistrict
                if self.districtIncidentCounts[district] != nil {
                    if let currentCount = self.districtIncidentCounts[district] {
                        let newCount = currentCount + 1
                        self.districtIncidentCounts[district] = newCount
                    }
                } else {
                    self.districtIncidentCounts[district] = 1
                }
                let title = incident.category
                let subtitle = incident.descript
                let x = incident.x
                let y = incident.y
                // Make another request with incident.pdistrict, run another for loop for each pddistrict, keep a count and store it in a has with respective pddistrict
                guard let lat = CLLocationDegrees(y), let long = CLLocationDegrees(x) else {
                    print("Could not retrieve incident coordinates")
                    return
                }
                let incidentLocation = CLLocation(latitude: lat, longitude: long)
                let coordinates = CLLocationCoordinate2DMake(incidentLocation.coordinate.latitude, incidentLocation.coordinate.longitude)
                let annotation = IncidentAnnotation(coordinate: coordinates, title: title, subtitle: subtitle, color: UIColor.redColor())
                self.incidentMapView.addAnnotation(annotation)
            }
            
            for key in self.districtIncidentCounts {
                print("\(key)")
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension IncidentMapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MKMapView Delegate delegate methods
    // Annotation methods
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
    
    // Overlay methods
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        return MKOverlayRenderer()
    }
    
    // Map helper functions
    func showOnMap(location initialLocation: CLLocation?, mapToShow map: MKMapView?) {
        guard let mapView = map else {
            print("Passed in map object is nil")
            return
        }
        guard let location = initialLocation else {
            print("Invalid coordinates for map")
            return
        }
        
        let mapCenter = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let mapSpan = MKCoordinateSpanMake(0.07, 0.09)
        
        mapView.region = MKCoordinateRegionMake(mapCenter, mapSpan)
    }
    
    // CLLocationManagerDelegate delegate methods
}

