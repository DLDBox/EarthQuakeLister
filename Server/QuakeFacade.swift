//
//  QuakeFacade.swift
//  DevoeQuakeLocator
//
//  Created by Dana Devoe on 5/12/20.
//  Copyright © 2020 Dana Devoe. All rights reserved.
//

import Foundation
import UIKit
import Network

class QuakeFacade: NSObject  {
    
    //
    //MARK: - private section
    //
    private let netMonitor: NWPathMonitor
    private var features: FeatureCollection?
    
    //
    //MARK: - public section
    //
    static let shared = QuakeFacade()
    
    var isInternetAccessible: Bool
    
    override init() {
        
        self.netMonitor = NWPathMonitor()
        self.isInternetAccessible = false
        self.features = nil
    
        super.init()
        self.setupCallBack()
    }
    
    func loadQuakeData( startTime: String, endTime: String, magnitude: Int, completion: @escaping ClosureWithBool ) {
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
    }
    
}

extension QuakeFacade: UITableViewDataSource {
    
    //
    //MARK: - UITableViewDataSource
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let features = self.features {
            return features.features?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
