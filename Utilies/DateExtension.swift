//
//  DateExtension.swift
//  DevoeQuakeLocator
//
//  Created by Dana Devoe on 5/14/20.
//  Copyright © 2020 Dana Devoe. All rights reserved.
//

import Foundation

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
        let components = calendar.dateComponents([.hour, .year, .minute], from: self)
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        let seconds = calendar.component(.second, from: self)
        
        return "\(hour):\(minutes):\(seconds)"
    }
}
