//
//  CityAPI.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/25.
//

import Foundation

enum CityAPI {
    
    case list
    
}

extension CityAPI: LocalTarget {
    
    var resource: String? {
        switch self {
        case .list:     return "citylist"
        }
    }
    
    var withExtension: String? {
        switch self {
        case .list:     return "json"
        }
    }
    
}
