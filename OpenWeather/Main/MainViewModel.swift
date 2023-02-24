//
//  MainViewModel.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import Foundation
import Moya
import RxSwift

final class MainViewModel {
    
    typealias RequestModel = Weather.ForecastRequestModel
    typealias ResponseModel = Weather.ForecastResponseModel
    
    init(weatherProvider: MoyaProvider<WeatherAPI>) {
        self.weatherProvider = weatherProvider
    }
    
    private func requestWeather(lat: String, lon: String) {
        let requestModel = RequestModel(lat: lat, lon: lon)
        self.weatherProvider
            .request(.forecast(requestModel: requestModel))
            .subscribe(onSuccess: { [weak self] (model: ResponseModel?) in
                self?.performAfterFetchingWeather(model)
            }, onFailure: { error in
                // TODO: - Handle Error
                print(error.localizedDescription)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func performAfterFetchingWeather(_ model: ResponseModel?) {
        
    }
    
    private let weatherProvider: MoyaProvider<WeatherAPI>
    private let disposeBag = DisposeBag()
    
}
