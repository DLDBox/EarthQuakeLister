//
//  QuakeServer.swift
//  DevoeQuakeLocator
//
//  Created by Dana Devoe on 5/11/20.
//  Copyright © 2020 Dana Devoe. All rights reserved.
//

import Foundation

/* This class handle downloading the quake FeatureCollection from the server
 */
class QuakeServer {

    // Download quake features for given time frame
    // Did not implment any threading as the UI has nothing to do until this call completes
    class func featuresFor( startTime: String, endTime: String, magnitude: Int? = nil
                , completion: @escaping ClosureWithFeatures, failure: @escaping ClosureWithError ) {
        
        func download( _ url: URL ) {
            
            let urlRequest = URLRequest(url: url)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: urlRequest, completionHandler: { (data,response,error) in
                
                if error != nil {
                    failure( .noData )
                } else if let data = data {
                    // Map the JSON to the FeatureCollection
                    do {
                        let featureCollection: FeatureCollection = try JSONDecoder().decode( FeatureCollection.self, from: data )
                        
                        if featureCollection.metadata?.status == 200 {
                            completion( featureCollection )
                        } else {
                            failure( QuakeErrors.netError(featureCollection.metadata?.status ?? 0) )
                        }
                    } catch {
                        failure( .unknown )
                    }
                    
                } else {
                    failure( .noData )
                }
            })
            
            task.resume()
        }
        
        var url: URL?
        if let magnitude = magnitude {
            url = URL( string: EndPoints.queryURLFor( startTime: startTime, endTime: endTime, magnitude: magnitude ) )
        } else {
            url = URL( string: EndPoints.queryURLFor( startTime: startTime, endTime: endTime ) )
        }
        
        if let url = url {
            download(url)
        } else {
            failure( .invalidRequest )
        }
    }
}
