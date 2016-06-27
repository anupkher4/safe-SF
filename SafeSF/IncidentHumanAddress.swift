//
//  IncidentHumanAddress.swift
//  SafeSF
//
//  Created by Anup Kher on 6/25/16.
//  Copyright © 2016 Globant. All rights reserved.
//

import Foundation

class IncidentHumanAddress {
    
    var address: String
    var city: String
    var state: String
    var zip: Int
    
    init(address: String, city: String, state: String, zip: Int) {
        self.address = address
        self.city = city
        self.state = state
        self.zip = zip
    }
}