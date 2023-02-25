//
//  WeatherAPI.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import Moya

enum WeatherAPI {
    
    case forecast(requestModel: Weather.ForecastRequestModel)
    
}

extension WeatherAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: Host.host)!
    }
    
    var path: String {
        switch self {
        case .forecast:     return "/forecast"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .forecast(let model):
            let params = model.parameters()
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
}
