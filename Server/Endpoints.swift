//
//  Endpoints.swift
//  DevoeQuakeLocator
//
//  Created by Dana Devoe on 5/10/20.
//  Copyright © 2020 Dana Devoe. All rights reserved.
//

import Foundation

/*
 PURPOSE:
 
 Manage the endpoint for the Earth Quake Hazards website
 https://earthquake.usgs.gov/fdsnws/event/1/
 
 */

struct EndPoints {
    
    static var starttimetag = "#starttime#"
    static var endtimetag = "#endtime#"
    static var magnitudetag = "#magnitudetag#"
    
    //
    //MARK: - Private section
    //
    static let mainURL = "https://earthquake.usgs.gov/fdsnws/event/1/"
    
    static var queryWithStartEndTime =  "https://earthquake.usgs.gov/fdsnws/event/1/" +
                                        "query?format=geojson&starttime=\(EndPoints.starttimetag)&endtime=\(EndPoints.endtimetag)"
    
    static var queryWithStartEndTimeMag =   "https://earthquake.usgs.gov/fdsnws/event/1/" +
                                            "query?format=geojson&starttime=\(EndPoints.starttimetag)&endtime=\(EndPoints.endtimetag)" +
                                            "&minmagnitude=\(EndPoints.magnitudetag)"

    
    static let methodsURL = "https://earthquake.usgs.gov/fdsnws/event/1/application.json"
    static let versionURL = "https://earthquake.usgs.gov/fdsnws/event/1/version"
    
    //
    //MARK: - public section
    //
    static func queryURLFor( startTime: String, endTime: String ) -> String {
        return queryWithStartEndTime.replacingOccurrences(of: EndPoints.starttimetag, with: startTime)
                                    .replacingOccurrences(of: EndPoints.endtimetag, with: endTime)
    }
    
    static func queryURLFor( startTime: String, endTime: String, magnitude: Int ) -> String {
        return queryWithStartEndTimeMag.replacingOccurrences(of: EndPoints.starttimetag, with: startTime)
                                    .replacingOccurrences(of: EndPoints.endtimetag, with: endTime)
                                    .replacingOccurrences(of: EndPoints.magnitudetag, with: "\(magnitude)" )

    }
    
}
