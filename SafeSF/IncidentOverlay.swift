//
//  IncidentOverlay.swift
//  SafeSF
//
//  Created by Anup Kher on 6/29/16.
//  Copyright © 2016 Globant. All rights reserved.
//

import Foundation
import MapKit

class IncidentOverlay: NSObject, MKOverlay {
    
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    
    init(coordinate: CLLocationCoordinate2D, boundingMapRect: MKMapRect) {
        self.coordinate = coordinate
        self.boundingMapRect = boundingMapRect
        
        super.init()
    }
}