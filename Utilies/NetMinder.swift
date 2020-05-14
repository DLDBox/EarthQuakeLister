//
//  NetMinder.swift
//  DevoeQuakeLocator
//
//  Created by Dana Devoe on 5/13/20.
//  Copyright © 2020 Dana Devoe. All rights reserved.
//

import Foundation
import UIKit
import Network

/* Manages the connection status and provides a mechanism to
 trigger a closure to handle a desired action when the
 connection status changes */
class NetMinder {
    
    //
    //MARK: - Private section
    //
    private let netMonitor: NWPathMonitor
    private var connectClosure: ClosureWithBool?
    private var isInternetAccessible: Bool
    private var alert: UIAlertController?

    //
    //MARK: - Public section
    //
    static let shared = NetMinder()
    

    init() {
        self.netMonitor = NWPathMonitor()
        self.isInternetAccessible = false
        self.connectClosure = nil

        self.setupCallBack()
    }
    
    func accessible( _ completion: @escaping ClosureWithBool ) {
        if self.isInternetAccessible {
            completion(true)
        } else {
            self.connectClosure = completion
        }
    }
    
    //
    //MARK: - helper section
    //
    private func setupCallBack() {
        self.netMonitor.pathUpdateHandler = { path in
            
            print( "path = \(path)" )
            
            if path.status == .satisfied {
                self.isInternetAccessible = true
                
                if let connectClosure = self.connectClosure {
                    connectClosure(true)
                    self.connectClosure = nil
                }
                
            } else {
                self.isInternetAccessible = false
                
                if self.alert == nil {
                    DispatchQueue.main.async {
                        self.alert = UIAlertController( title:"Network Access Error", message: "Please connect to the internet", preferredStyle: .alert )
                        self.alert?.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
                            self.alert = nil
                        }))
                        
                        self.alert?.show()
                    }
                }
            }
        }
        
        let queue = DispatchQueue.global(qos: .background)
        self.netMonitor.start(queue: queue)
    }
    
}

