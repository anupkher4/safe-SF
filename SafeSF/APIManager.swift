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
    let endpoint = SocrataEndpoints.SFPDIncidentsEndpoint.baseEndpoint
    
    func getIncidentReports(_ completion: @escaping (([Incident])?) -> ()) {
        
        var allIncidents = [Incident]()
        
        // HTTP headers
        let headers = [
            "X-App-Token" : appToken
        ]
        
        
        Alamofire.request(endpoint, headers: headers).responseJSON(completionHandler: {
            response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print("Response from server: \(json)")
                // Loop over incidents
                for (_, subJson):(String, JSON) in json {
                    let incident = Incident(json: subJson)
                    allIncidents.append(incident)
                }
                completion(allIncidents)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        })
    }
    
    func getLastMonthsIncidents(_ completion: @escaping (([Incident])?) -> ()) {
        
        // Get today's date
        let today = Date()
        
        // Set-up calender to calculate 1 month ago from now
        let gregorian = Calendar.init(identifier: Calendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.month = -1
        guard let oneMonthAgo = (gregorian as NSCalendar).date(byAdding: offsetComponents, to: today, options: .matchFirst) else {
            print("Could not get a month ago")
            return
        }
        
        // Format the date for SODA API call
        let jsonDateFormatter = DateFormatter()
        jsonDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        let formattedToday = jsonDateFormatter.string(from: today)
        let formattedOneMonthAgo = jsonDateFormatter.string(from: oneMonthAgo)
        
        // Build query for fetching incidents from last month till today
        let query = "?$where=date between '\(formattedOneMonthAgo)' and '\(formattedToday)'&$order=date DESC&$limit=50"
        let newEndpoint = "\(SocrataEndpoints.SFPDIncidentsEndpoint.baseEndpoint)\(query)"
        
        guard let formattedEndpoint = newEndpoint.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            print("Could not format url string")
            return
        }
        
        var allIncidents = [Incident]()
        
        // HTTP headers
        let headers = [
            "X-App-Token" : appToken
        ]
        
        print("\(newEndpoint)")
        
        Alamofire.request(formattedEndpoint, headers: headers).responseJSON(completionHandler: {
            response in
            
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                // Loop over incidents
                for (_, subJson):(String, JSON) in json {
                    let incident = Incident(json: subJson)
                    allIncidents.append(incident)
                }
                completion(allIncidents)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        })
    }
    
}
