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

    // List of returned incidents
    var returnedIncidents = [Incident]()
    
    // Incident count per district
    var districtIncidentCounts = [String : Int]()
    // Sorted counts
    var sortedDistricts = [String]()
    
    // Total number of colors
    var noOfColors = 8
    var incidentPinColor = UIColor()
    
    @IBOutlet var incidentMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        incidentMapView.delegate = self
        
        showOnMap(location: initialLocation, mapToShow: incidentMapView)
        
        apiManager.getLastMonthsIncidents({ incidents in
            guard let allIncidents = incidents else {
                print("No incidents to show")
                return
            }
            
            print("No of incidents: \(allIncidents.count)")
            
            self.returnedIncidents = allIncidents
            
            // Calculate incident counts for each district
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
            }
            
            // Sort district names by count
            self.sortedDistricts = self.districtIncidentCounts.sortedKeysByValue(<)
            
            //let caseIndex = self.sortedDistricts.count/self.noOfColors
            
            // Add a pin on map for each incident
            for incident in self.returnedIncidents {
                let district = incident.pddistrict
                let title = incident.category
                let subtitle = incident.descript
                let x = incident.x
                let y = incident.y
                guard let lat = CLLocationDegrees(y), let long = CLLocationDegrees(x) else {
                    print("Could not retrieve incident coordinates")
                    return
                }
                
                let pinColor = self.colorForDistrictCount(districtName: district)
                let incidentLocation = CLLocation(latitude: lat, longitude: long)
                let coordinates = CLLocationCoordinate2DMake(incidentLocation.coordinate.latitude, incidentLocation.coordinate.longitude)
                
                let annotation = IncidentAnnotation(coordinate: coordinates, title: title, subtitle: subtitle, color: pinColor, detail: incident)
                
                self.incidentMapView.addAnnotation(annotation)
            }
            
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func colorForDistrictCount(districtName name: String) -> UIColor {
        
        if let districtIndex = self.sortedDistricts.indexOf(name) {
            switch Int(districtIndex) {
            case 0:
                return UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.0)
            case 1:
                return UIColor(red: 0.92, green: 0.21, blue: 0.00, alpha: 1.0)
            case 2:
                return UIColor(red: 0.90, green: 0.28, blue: 0.00, alpha: 1.0)
            case 3:
                return UIColor(red: 0.85, green: 0.43, blue: 0.00, alpha: 1.0)
            case 4:
                return UIColor(red: 0.82, green: 0.50, blue: 0.00, alpha: 1.0)
            case 5:
                return UIColor(red: 0.77, green: 0.64, blue: 0.00, alpha: 1.0)
            case 6:
                return UIColor(red: 0.73, green: 0.78, blue: 0.00, alpha: 1.0)
            default:
                return UIColor(red: 0.65, green: 1.00, blue: 0.00, alpha: 1.0)
            }
        } else {
            return UIColor.purpleColor()
        }
        
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
                if let currentAnnotation = annotation as? IncidentAnnotation {
                    if let pincolor = currentAnnotation.pincolor {
                        pinView?.pinTintColor = pincolor
                    }
                } else {
                    pinView?.pinTintColor = UIColor.purpleColor()
                }
                pinView?.animatesDrop = false
                pinView?.canShowCallout = true
                
                // Customizing the callout by adding accessory views
                
                // Adding a detail disclosure button to the callout on the right
                let rightButton: UIButton = UIButton(type: .DetailDisclosure)
                rightButton.addTarget(nil, action: nil, forControlEvents: .TouchUpInside)
                pinView?.rightCalloutAccessoryView = rightButton
                
                // Adding a custom image to the callout on the left
//                let calloutCustomImage: UIImageView = UIImageView(image: UIImage(named: "SFPDPatch"))
//                pinView?.leftCalloutAccessoryView = calloutCustomImage
            } else {
                pinView?.annotation = annotation
            }
            
            return pinView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Show detail view for right accessory button
        
        if let currentAnnotaion = view.annotation as? IncidentAnnotation {
            // Perform segue to detail view
            
        }
        
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

extension Dictionary {
    func sortedKeys(isOrderedBefore:(Key,Key) -> Bool) -> [Key] {
        return Array(self.keys).sort(isOrderedBefore)
    }
    
    func sortedKeysByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return sortedKeys {
            isOrderedBefore(self[$0]!, self[$1]!)
        }
    }
}
