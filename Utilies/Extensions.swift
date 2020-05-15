//
//  DateExtension.swift
//  DevoeQuakeLocator
//
//  Created by Dana Devoe on 5/14/20.
//  Copyright © 2020 Dana Devoe. All rights reserved.
//

import Foundation
import UIKit

//
//MARk: - Date Extension section
//
extension Date {
    
    func toYYYYMMDD() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
    
    func fromYYYYMMDD( string: String ) -> Date? {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from: string)
    }
    
    func toHHMM() -> String? {
        var calendar = Calendar.current

        calendar.timeZone = TimeZone(identifier: "UTC")!
        //let components = calendar.dateComponents([.hour, .year, .minute], from: self)
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        //let seconds = calendar.component(.second, from: self)
        
        return "\(hour):\(minutes)"
    }
}

//
//MARK: - UIAlertController Extension section
//
extension UIAlertController {

    func show() {
        present(animated: true, completion: nil)
    }

    func present(animated: Bool, completion: (() -> Void)?) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if let rootVC = window?.rootViewController {
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
