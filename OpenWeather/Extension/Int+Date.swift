//
//  Int+Date.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import Foundation

extension Int {
    
    var toDate: Date? {
        let unix = Double(self)
        return Date(timeIntervalSince1970: unix)
    }
    
}
