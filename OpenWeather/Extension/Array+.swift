//
//  Array+.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import Foundation

extension Array {
    
    subscript (safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
    
}
