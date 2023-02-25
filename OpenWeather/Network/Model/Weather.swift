//
//  Weather.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import Foundation

enum Weather {
    
    // https://openweathermap.org/forecast5
    
    struct ForecastRequestModel: Encodable {
        
        // Required
        let lat: String
        let lon: String
        let appId: String
        
        // Optional
        let units: String?
        let mode: String?
        let cnt: String?
        let lang: String?
        
        init(
            lat: String,
            lon: String,
            appId: String = APIKey.key,
            units: String? = "metric",
            mode: String? = nil,
            cnt: String? = nil,
            lang: String? = "kr" // https://openweathermap.org/forecast5#data
        ) {
            self.lat = lat
            self.lon = lon
            self.appId = appId
            self.units = units
            self.mode = mode
            self.cnt = cnt
            self.lang = lang
        }
        
    }
    
}

extension Weather {
    
    struct ForecastResponseModel: Decodable {
        
        let cod: String?
        let message: Int?
        let cnt: Int?
        let list: [ForecastDetail]?
        let city: ForecastCity?
        
        struct ForecastDetail: Decodable {
            let dt: Int?
            let main: ForecastDetailMain?
            let weather: [ForecastDetailWeather]?
            let clouds: ForecastDetailCloud?
            let wind: ForecastDetailWind?
            let visibility: Int?
            let pop: Double?
            let dt_txt: String? // 2022-08-30 15:00:00
            
//            let rain: ForecastDetailRain?
//            let sys: ForecastDetailSys?
        }
        
        struct ForecastCity: Decodable {
            
            let id: Int?
            let name: String?
            
        }
        
        struct ForecastDetailMain: Decodable {
            
            let temp: Double?
            let feels_like: Double?
            let temp_min: Double?
            let temp_max: Double?
            let pressure: Int?
            let sea_level: Int?
            let grnd_level: Int?
            let humidity: Int?
            let temp_kf: Double?
            
        }
        
        struct ForecastDetailWeather: Decodable {
            
            let id: Int?
            let main: String?
            let description: String?
            let icon: String?
            
        }
        
        struct ForecastDetailCloud: Decodable {
            
            let all: Int?
            
        }
        
        struct ForecastDetailWind: Decodable {
            
            let speed: Double?
            let deg: Int?
            let gust: Double?
            
        }
        
//        struct ForecastDetailRain: Decodable {
//            let 3h: Double?
//        }
//
//        struct ForecastDetailSys: Decodable {
//            let pod: String?
//        }
        
    }
    
}
