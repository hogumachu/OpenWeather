//
//  MainViewReactor.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import Foundation
import Moya
import RxSwift
import RxRelay
import ReactorKit

final class MainViewReactor: Reactor {
    
    typealias RequestModel = Weather.ForecastRequestModel
    typealias ResponseModel = Weather.ForecastResponseModel
    
    enum Action {
        
        case updateLocation(location: Location)
        
    }
    
    enum Mutation {
        
        case updateSection(model: ResponseModel?, location: Location)
        
    }
    
    struct State {
        
        var currentForecast: ResponseModel.ForecastDetail?
        var currentWeather: String?
        var sections: [MainSection]
        
    }
    
    let initialState: State = State(
        currentForecast: nil,
        currentWeather: nil,
        sections: []
    )
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateLocation(let location):
            return self.requestWeather(location: location)
                .take(until: self.action.filter(Action.isUpdateLocationAction))
                .map { Mutation.updateSection(model: $0, location: location) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateSection(let model, let location):
            if let model = model {
                let currentForecast = self.makeCurrentForecast(model)
                newState.currentForecast  = currentForecast
                newState.currentWeather = self.makeCurrentWeather(forecast: currentForecast)
                newState.sections = self.makeSections(model, location: location)
            }
        }
        return newState
    }
    
    init(weatherProvider: MoyaProvider<WeatherAPI>) {
        self.weatherProvider = weatherProvider
    }
    
    func reactorForSearch() -> SearchViewReactor {
        let cityProvider = LocalProvider<CityAPI>()
        return SearchViewReactor(cityProvider: cityProvider)
    }
    
    private func requestWeather(location: Location) -> Observable<ResponseModel?> {
        let requestModel = RequestModel(lat: String(location.lat), lon: String(location.lon))
        return self.weatherProvider
            .request(.forecast(requestModel: requestModel))
            .map { (model: ResponseModel?) in return model }
            .asObservable()
    }
    
    private let dateManager = DateManager()
    
    private let weatherProvider: MoyaProvider<WeatherAPI>
    private let disposeBag = DisposeBag()
    
}

extension MainViewReactor {
    
    // MARK: - Generate
    
    private func makeCurrentForecast(_ model: ResponseModel?) -> ResponseModel.ForecastDetail? {
        return model?.list?.first
    }
    
    private func makeCurrentWeather(forecast: ResponseModel.ForecastDetail?) -> String? {
        guard let forecast = forecast else { return nil }
        guard let weather = forecast.weather?.first?.main else { return nil }
        switch weather.lowercased() {
        case "clouds", "fog", "rain", "sunny":  return weather.lowercased()
        default:                                return "sunny"
        }
    }
    
    // MARK: - Generate Sections
    
    private func makeSections(_ model: ResponseModel, location: Location) -> [MainSection] {
        var sections: [MainSection] = []
        sections.append(self.makeHeaderSection(model))
        sections.append(self.makeTodayWeatherSection(model))
        sections.append(self.makeWeatherSection(model))
        sections.append(self.makePrecipitationSection(location: location))
        sections.append(self.makeETCSection(model))
        return sections
    }
    
    private func makeHeaderSection(_ model: ResponseModel) -> MainSection {
        guard let name = model.city?.name,
              let temp = model.list?.first?.main?.temp,
              let weather = model.list?.first?.weather?.first?.description,
              let minTemp = model.list?.first?.main?.temp_min,
              let maxTemp = model.list?.first?.main?.temp_max
        else {
            return .init(items: [])
        }
        let tempDescription = "\(Int(temp))°"
        let tempDetailDescription = "최고: \(Int(maxTemp))° | 최저: \(Int(minTemp))°"
        return .init(items: [.header(.init(city: name, temp: tempDescription, weather: weather, tempDetail: tempDetailDescription))])
    }
    
    private func makeTodayWeatherSection(_ model: ResponseModel) -> MainSection {
        guard let list = model.list else { return .init(items: []) }
        guard let firstDT = list.first?.dt, let now = firstDT.toDate else { return .init(items: []) }
        let windSpeed = Int(list.first?.wind?.speed ?? 0.0)
        let titleItem: MainTitleTableViewCellModel = .init(title: "돌풍의 풍속은 최대 \(windSpeed)m/s입니다.", style: .normal)
        let items = list.compactMap { item -> MainTodayWeatherCollectionViewCellModel? in
            guard let dt = item.dt,
                  let time = dt.toDate,
                  let icon = item.weather?.first?.icon,
                  let temp = item.main?.temp,
                  let daysBetween = self.dateManager.daysBetween(from: now, to: time),
                  daysBetween <= 1 // 최대 2일까지 생성
            else {
                return nil
            }
            let timeDescription = self.dateManager.hoursBetween(from: now, to: time) == 0 ? "지금" : self.dateManager.toHourString(date: time)
            let iconURL = "https://openweathermap.org/img/wn/\(icon)@2x.png" // Asset 에 없는 이미지가 있어서 API 에서 다운로드
            let tempDescription = "\(Int(temp))°"
            return .init(time: timeDescription, icon: iconURL, temp: tempDescription)
        }
        return .init(items: [.title(titleItem), .todayWeather(.init(collectionViewCellModels: items))])
    }
    
    private func makeWeatherSection(_ model: ResponseModel) -> MainSection {
        guard let list = model.list else { return .init(items: []) }
        guard let firstDT = list.first?.dt, let now = firstDT.toDate else { return .init(items: []) }
        let titleItem: MainTitleTableViewCellModel = .init(title: "5일간의 일기예보", style: .secondary)
        let items = (0...5).compactMap { daysBetween -> MainItem? in
            let items = list.filter {
                guard let date = $0.dt?.toDate, let between = self.dateManager.daysBetween(from: now, to: date) else { return false }
                return between == daysBetween
            }
            guard let firstItem = items.first,
                  let firstDate = firstItem.dt?.toDate,
                  let icon = firstItem.weather?.first?.icon,
                  let minTemp = items.compactMap({ $0.main?.temp_min }).min(),
                  let maxTemp = items.compactMap({ $0.main?.temp_max }).max()
            else {
                return nil
            }
            let dayOfWeek = daysBetween == 0 ? "오늘" : self.dateManager.dayOfWeek(date: firstDate)
            let iconURL = "https://openweathermap.org/img/wn/\(icon)@2x.png" // Asset 에 없는 이미지가 있어서 API 에서 다운로드
            let tempDescription = "최소: \(Int(minTemp))° 최대: \(Int(maxTemp))°"
            
            return .weather(.init(dayOfWeek: dayOfWeek, icon: iconURL, temp: tempDescription))
        }
        
        return .init(items: [.title(titleItem)] + items)
    }
    
    private func makePrecipitationSection(location: Location) -> MainSection {
        return .init(items: [.precipitation(.init(lat: location.lat, lon: location.lon))])
    }
    
    private func makeETCSection(_ model: ResponseModel) -> MainSection {
        let humidity = model.list?.first?.main?.humidity ?? 0
        let clouds = model.list?.first?.clouds?.all ?? 0
        let gust = model.list?.first?.wind?.gust ?? 0
        let windSpeed = model.list?.first?.wind?.speed ?? 0
        let level = model.list?.first?.main?.grnd_level ?? 0
        
        return .init(items: [.etc(.init(collectionViewCellModels: [
            .init(title: "습도", content: "\(humidity)%", description: nil),
            .init(title: "구름", content: "\(clouds)%", description: nil),
            .init(title: "바람 속도", content: "\(gust)m/s", description: "강풍: \(windSpeed)m/s"),
            .init(title: "기압", content: "\(level)hpa", description: nil)
        ]))])
    }
    
}

extension MainViewReactor.Action {
    
    static func isUpdateLocationAction(_ action: MainViewReactor.Action) -> Bool {
        if case .updateLocation = action {
            return true
        } else {
            return false
        }
    }
    
}
