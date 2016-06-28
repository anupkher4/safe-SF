//
//  Incident.swift
//  SafeSF
//
//  Created by Anup Kher on 6/25/16.
//  Copyright © 2016 Globant. All rights reserved.
//

import Foundation
import SwiftyJSON

class Incident {
    
    var address: String
    var category: String
    var date: String
    var dayofweek: String
    var descript: String
    var incidntnum: String
    var pddistrict: String
    var pdid: String
    var resolution: String
    var time: String
    var x: String
    var y: String
    
    init(address: String, category: String, date: String, dayofweek: String, descript: String, incidntnum: String, pddistrict: String, pdid: String, resolution: String, time: String, x: String, y: String) {
        self.address = address
        self.category = category
        self.date = date
        self.dayofweek = dayofweek
        self.descript = descript
        self.incidntnum = incidntnum
        self.pddistrict = pddistrict
        self.pdid = pdid
        self.resolution = resolution
        self.time = time
        self.x = x
        self.y = y
    }
    
    init(json: JSON) {
        self.address = json["address"].stringValue
        self.category = json["category"].stringValue
        self.date = json["date"].stringValue
        self.dayofweek = json["dayofweek"].stringValue
        self.descript = json["descript"].stringValue
        self.incidntnum = json["incidntnum"].stringValue
        self.pddistrict = json["pddistrict"].stringValue
        self.pdid = json["pdid"].stringValue
        self.resolution = json["resolution"].stringValue
        self.time = json["time"].stringValue
        self.x = json["x"].stringValue
        self.y = json["y"].stringValue
    }
}