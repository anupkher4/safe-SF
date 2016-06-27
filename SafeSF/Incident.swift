//
//  Incident.swift
//  SafeSF
//
//  Created by Anup Kher on 6/25/16.
//  Copyright © 2016 Globant. All rights reserved.
//

import Foundation

class Incident {
    
    var time: NSDate
    var category: String
    var pddistrict: String
    var pdid: Int
    var location: IncidentLocation
    var address: String
    var descript: String
    var dayofweek: String
    var resolution: String
    var date: NSDate
    var y: Double
    var x: Double
    var incidntnum: Int
    
    init(time: NSDate, category: String, pddistrict: String, pdid: Int, location: IncidentLocation, address: String, descript: String, dayofweek: String, resolution: String, date: NSDate, y: Double, x: Double, incidntnum: Int) {
        self.time = time
        self.category = category
        self.pddistrict = pddistrict
        self.pdid = pdid
        self.location = location
        self.address = address
        self.descript = descript
        self.dayofweek = dayofweek
        self.resolution = resolution
        self.date = date
        self.y = y
        self.x = x
        self.incidntnum = incidntnum
    }
}