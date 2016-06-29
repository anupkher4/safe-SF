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
    
    func getIncidentReports(withFilter filter: IncidentFilters? = nil, value: String? = nil, completion: ([Incident])? -> ()) {
        
        var allIncidents = [Incident]()
        
        // HTTP headers
        let headers = [
            "X-App-Token" : appToken
        ]
        
        if filter == nil {
            
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
                        completion(allIncidents)
                    }
                case .Failure(let error):
                    print(error)
                    completion(nil)
                }
            })
            
        } else {
            guard let parameter = filter else {
                print("Invalid filter")
                return
            }
            guard let paramValue = value else {
                print("Invalid filter value")
                return
            }
            Alamofire.request(.GET, endpoint + "?\(parameter.rawValue)=\(paramValue)", headers: headers).responseJSON(completionHandler: {
                response in
                
                switch response.result {
                case .Success(let value):
                    let json = JSON(value)
                    // Loop over incidents
                    for (_, subJson):(String, JSON) in json {
                        let incident = Incident(json: subJson)
                        allIncidents.append(incident)
                        completion(allIncidents)
                    }
                case .Failure(let error):
                    print(error)
                    completion(nil)
                }
            })
        }
    }
    
}
