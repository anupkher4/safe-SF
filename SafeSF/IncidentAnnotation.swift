//
//  IncidentAnnotation.swift
//  SafeSF
//
//  Created by Anup Kher on 6/26/16.
//  Copyright © 2016 Globant. All rights reserved.
//

import Foundation
import MapKit

class IncidentAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var pincolor: UIColor?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, color: UIColor?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.pincolor = color
        
        super.init()
    }
    
}