//
//  City.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import Foundation

enum City {
    
    struct ResponseModel: Decodable {
        
        let id: Int?
        let name: String?
        let country: String?
        let coord: CityLocation?
        
        struct CityLocation: Decodable {
            
            let lat: Double?
            let lon: Double?
            
        }
        
    }
    
}
