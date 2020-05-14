//
//  QuakeDataSource.swift
//  DevoeQuakeLocator
//
//  Created by Dana Devoe on 5/13/20.
//  Copyright © 2020 Dana Devoe. All rights reserved.
//

import Foundation
import UIKit
import Network

class QuakeDataSource: NSObject, UITableViewDataSource {
    
    //
    //MARK: - private section
    //
    private let netMonitor: NWPathMonitor
    private var features: FeatureCollection?
    
    //
    //MARK: - public section
    //
    static let shared = QuakeDataSource()
    
    var isInternetAccessible: Bool
    
    override init() {
        
        self.netMonitor = NWPathMonitor() // TODO: create separate class for this object
        self.isInternetAccessible = false
        self.features = nil
    
        super.init()
        self.setupCallBack()
    }
    
    func loadQuakeData( startTime: String, endTime: String, magnitude: Int?, completion: @escaping ClosureWithBool ) { //TODO: perhaps add a failure closure
        self.features = nil
        
        if self.isInternetAccessible {
            
            QuakeServer.featuresFor(startTime: startTime, endTime: endTime, magnitude: magnitude, completion: { recvFeatures in
                self.features = recvFeatures
                completion(true)
            }, failure: { error in
                completion(false)
            })
            
        } else { // since there was no connection lets retry
            //completion(false)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.loadQuakeData(startTime: startTime, endTime: endTime, magnitude: magnitude, completion: completion )
            })
        }
    }
    
    //
    //MARK: - helper section
    //
    func setupCallBack() {
        self.netMonitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isInternetAccessible = true
            } else {
                self.isInternetAccessible = false
            }
        }
        
        let queue = DispatchQueue.global(qos: .background)
        self.netMonitor.start(queue: queue)
    }
    
}

//
//MARK: - UITableViewDataSource
//
extension QuakeDataSource {
    
    var featureCount: Int { get {return features?.features?.count ?? 0} }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let features = self.features {
            return features.features?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quakeCell: QuakeCell = tableView.dequeueReusableCell( withIdentifier: "QuakeCell", for: indexPath ) as! QuakeCell
        let properties = self.featureAt(indexPath)?.properties
        
        quakeCell.title.text = properties?.place
        quakeCell.magnitude.text = "\(properties?.mag ?? 0.0)"
        quakeCell.time.text = properties?.time?.toHHMM() //TODO: convert Date to a string
        
        return quakeCell
    }

    //
    //MARK: - Custom accessor
    //
    
    func featureAt( _ indexPath: IndexPath ) -> Feature? {
        if let features = self.features?.features, indexPath.row < features.count {
            return features[indexPath.row]
        }
        return nil
    }
    
    func featureDetailAt( _ indexPath: IndexPath ) -> String? {
        if let features = self.features?.features, indexPath.row < features.count {
            let properties = features[indexPath.row].properties
            
            return properties?.detail
        }
        
        return nil
    }
    
    func featureURLAt( _ indexPath: IndexPath ) -> String? {
        if let features = self.features?.features, indexPath.row < features.count {
            let properties = features[indexPath.row].properties
            
            return properties?.url
        }
        
        return nil
    }
    
}

