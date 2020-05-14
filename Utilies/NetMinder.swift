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
            if path.status == .satisfied {
                self.isInternetAccessible = true
                
                if let connectClosure = self.connectClosure {
                    connectClosure(true)
                    self.connectClosure = nil
                }
                
            } else {
                self.isInternetAccessible = false
                
                DispatchQueue.main.async {
                    self.alert = UIAlertController( title:"Network Access Error", message: "Please connect to the internet", preferredStyle: .alert )
                    self.alert?.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    
                    self.alert?.show()
                }
            }
        }
        
        let queue = DispatchQueue.global(qos: .background)
        self.netMonitor.start(queue: queue)
    }
    
}

extension UIAlertController {

    func show() {
        present(animated: true, completion: nil)
    }

    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }

    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        } else
            if let tabVC = controller as? UITabBarController,
                let selectedVC = tabVC.selectedViewController {
                presentFromController(controller: selectedVC, animated: animated, completion: completion)
            } else {
                controller.present(self, animated: animated, completion: completion);
        }
    }
}
