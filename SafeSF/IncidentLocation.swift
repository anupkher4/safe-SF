//
//  IncidentLocation.swift
//  SafeSF
//
//  Created by Anup Kher on 6/25/16.
//  Copyright © 2016 Globant. All rights reserved.
//

import Foundation

class IncidentLocation {
    
    var needs_recording: Bool
    var longitude: Double
    var latitude: Double
    var human_address: IncidentHumanAddress
    
    init(needs_recording: Bool, longitude: Double, latitude: Double, human_address: IncidentHumanAddress) {
        self.needs_recording = needs_recording
        self.longitude = longitude
        self.latitude = latitude
        self.human_address = human_address
    }
}