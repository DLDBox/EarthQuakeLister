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
    private var features: FeatureCollection?
    
    //
    //MARK: - public section
    //
    static let shared = QuakeDataSource()
    
    override init() {
        
        self.features = nil
    
        super.init()
    }
    
    func loadQuakeData( startTime: String, endTime: String, magnitude: Int?, completion: @escaping ClosureWithBool ) { 
        self.features = nil
        
        NetMinder.shared.accessible { yes in
            
            if yes {
                QuakeServer.featuresFor(startTime: startTime, endTime: endTime, magnitude: magnitude, completion: { recvFeatures in
                    self.features = recvFeatures
                    completion(true)
                }, failure: { error in
                    completion(false)
                })
            }
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuakeCell", for: indexPath)
        let properties = self.featureAt(indexPath)?.properties
        
        cell.textLabel?.text = properties?.place
        cell.detailTextLabel?.text = "Time: \(properties?.time?.toHHMM() ?? "") - Magnitude: \(properties?.mag ?? 0.0)"

        return cell
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

