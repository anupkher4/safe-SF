//
//  APIManager.swift
//  SafeSF
//
//  Created by Anup Kher on 6/27/16.
//  Copyright © 2016 Globant. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
    let appToken = "QbuTKtVG9a2vvjoiiBaURnopW"
    let endpoint = SocrataEndpoints.SFPDIncidentsEndpoint.limitEndpoint
    
    func getIncidentReports(completion: ([Incident])? -> ()) {
        
        var allIncidents = [Incident]()
        
        // HTTP headers
        let headers = [
            "X-App-Token" : appToken
        ]
        
        Alamofire.request(.GET, endpoint, headers: headers).responseJSON(completionHandler: {
            response in
            
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
                //print("Response from server: \(json)")
                // Loop over incidents
                for (_, subJson):(String, JSON) in json {
                    let incident = Incident(json: subJson)
                    allIncidents.append(incident)
                }
                completion(allIncidents)
            case .Failure(let error):
                print(error)
                completion(nil)
            }
        })
    }
    
    func getLastMonthsIncidents(completion: ([Incident])? -> ()) {
        
        // Get today's date
        let today = NSDate()
        
        // Set-up calender to calculate 1 month ago from now
        let gregorian = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        let offsetComponents = NSDateComponents()
        offsetComponents.month = -1
        guard let greg = gregorian else {
            print("Invalid calender instance")
            return
        }
        guard let oneMonthAgo = greg.dateByAddingComponents(offsetComponents, toDate: today, options: .MatchFirst) else {
            print("Could not get a month ago")
            return
        }
        
        // Format the date for SODA API call
        let jsonDateFormatter = NSDateFormatter()
        jsonDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        let formattedToday = jsonDateFormatter.stringFromDate(today)
        let formattedOneMonthAgo = jsonDateFormatter.stringFromDate(oneMonthAgo)
        
        // Build query for fetching incidents from last month till today
        let query = "?$where=date between '\(formattedOneMonthAgo)' and '\(formattedToday)'&$order=date DESC&$limit=\(50)"
        let newEndpoint = "\(SocrataEndpoints.SFPDIncidentsEndpoint.baseEndpoint)\(query)"
        
        var allIncidents = [Incident]()
        
        // HTTP headers
        let headers = [
            "X-App-Token" : appToken
        ]
        
        print("\(newEndpoint)")
        
        Alamofire.request(.GET, newEndpoint, headers: headers).responseJSON(completionHandler: {
            response in
            
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
                //print("Response from server: \(json)")
                // Loop over incidents
                for (_, subJson):(String, JSON) in json {
                    let incident = Incident(json: subJson)
                    allIncidents.append(incident)
                }
                completion(allIncidents)
            case .Failure(let error):
                print(error)
                completion(nil)
            }
        })
    }
    
}
