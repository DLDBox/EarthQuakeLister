//
//  NetMinder.swift
//  DevoeQuakeLocator
//
//  Created by Dana Devoe on 5/13/20.
//  Copyright © 2020 Dana Devoe. All rights reserved.
//

import Foundation
import Network

/* Manages the connection status and provides a mechanism to
 trigger a closure to handle a desired action when the
 connection status changes */
class NetMinder {
    
    //
    //MARK: - Private section
    //
    private let netMonitor: NWPathMonitor
    private var isInternetAccessible: Bool
    private var minders: [(ClosureWithAny?,ClosureWithAny?)]
    
    //
    //MARK: - Public section
    //
    static let shared = NetMinder()
    
    init() {
        self.netMonitor = NWPathMonitor()
        self.minders = [(ClosureWithAny?,ClosureWithAny?)]()
        self.isInternetAccessible = false

        self.setupCallBack()
    }
    
    func addMinder( _ connectionMinder: ClosureWithAny?
                  , _ disconnectionMinder: ClosureWithAny? ) -> Int {
        
        self.minders.append( (connectionMinder,disconnectionMinder) )
        return self.minders.count - 1
    }
    
    func removeMinder( minderID: Int ) {
        let _ = self.minders.remove(at: minderID)
    }
    
    func removeAllMinders(){
        self.minders.removeAll()
    }
    
    func connectionTest( connected: ClosureWithAny?, disconnected: ClosureWithAny? ){
        
        let tempMinderConnected: ClosureWithAny = { sender in
            connected?(nil)
            
            if let id = self.findMinder(minder: connected) {
                self.removeMinder(minderID: id)
            }
        }
        
        let tempMinderDisconnected: ClosureWithAny = { sender in
            disconnected?(nil)
            
            if let id = self.findMinder(minder: disconnected) {
                self.removeMinder(minderID: id)
            }
        }
        
        var minder: (ClosureWithAny?,ClosureWithAny?) = (nil,nil)
        if let connected = connected {
            if self.isInternetAccessible {
                connected(nil)
            } else {
                minder.0 = tempMinderConnected
            }
        } else if let disconnected = disconnected {
            if self.isInternetAccessible {
                minder.1 = tempMinderDisconnected
            } else {
                disconnected(nil)
            }
        }
        
        if minder.0 == nil && minder.1 == nil {
            self.minders.append(minder)
        }
    }
    
    //
    //MARK: - helper section
    //
    private func setupCallBack() {
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
    
    func findMinder( minder: ClosureWithAny? ) -> Int? {
        
        for index in 0..<self.minders.count {
            let minderTruple = self.minders[index]
            if minderTruple.0 as AnyObject? === minder as AnyObject? ||
               minderTruple.1 as AnyObject? === minder as AnyObject? {
                return index
            }
        }
        return nil
    }

}
