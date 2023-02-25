//
//  MainViewModel.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import Foundation
import Moya
import RxSwift
import RxRelay

enum MainViewModelEvent {
    
    case reloadData
    case showSearchView(SearchViewModel)
    
}

final class MainViewModel {
    
    typealias RequestModel = Weather.ForecastRequestModel
    typealias ResponseModel = Weather.ForecastResponseModel
    
    enum Section {
        
        case todayWeather([Item])
        case fiveDayWeather([Item])
        case precipitation(Item)
        case etc(Item)
        
        var items: [Item] {
            switch self {
            case .todayWeather(let items):          return items
            case .fiveDayWeather(let items):        return items
            case .precipitation(let item):          return [item]
            case .etc(let item):                    return [item]
            }
        }
        
    }
    
    enum Item {
        
        case title(MainTitleTableViewCellModel)
        case todayWeather(MainTodayWeatherCollectionTableViewCellModel)
        case weather(MainWeatherTableViewCellModel)
        case precipitation(MainPrecipitationTableViewCellModel)
        case etc(MainETCTCollectionTableViewCellModel)
        
    }
    
    var viewModelEvent: Observable<MainViewModelEvent> {
        self.viewModelEventRelay.asObservable()
    }
    
    var numberOfSections: Int {
        return self.sections.count
    }
    
    init(weatherProvider: MoyaProvider<WeatherAPI>) {
        self.weatherProvider = weatherProvider
        self.requestWeather(lat: self.currentLocation.lat, lon: self.currentLocation.lon)
    }
    
    func cellDidSelect(at indexPath: IndexPath) {
        
    }
    
    func searchTextFieldDidTap() {
        let cityProvider = LocalProvider<CityAPI>()
        let searchViewModel = SearchViewModel(cityProvider: cityProvider)
        self.viewModelEventRelay.accept(.showSearchView(searchViewModel))
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.sections[safe: section]?.items.count ?? 0
    }
    
    func item(at indexPath: IndexPath) -> Item? {
        guard let section = self.sections[safe: indexPath.section] else { return nil }
        return section.items[safe: indexPath.row]
    }
    
    func headerModel(_ section: Int) -> MainHeaderViewModel? {
        guard section == 0 else { return nil }
        return self.headerViewModel
    }
    
    private func requestWeather(lat: Double, lon: Double) {
        let requestModel = RequestModel(lat: String(lat), lon: String(lon))
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
        guard let model = model else {
            // TODO: - Handle Error
            return
        }
        
        self.headerViewModel = self.makeHeaderViewModel(model)
        self.sections = self.makeSections(model)
        self.viewModelEventRelay.accept(.reloadData)
    }
    
    private func makeHeaderViewModel(_ model: ResponseModel) -> MainHeaderViewModel? {
        guard let name = model.city?.name,
              let temp = model.list?.first?.main?.temp,
              let weather = model.list?.first?.weather?.first?.description,
              let minTemp = model.list?.first?.main?.temp_min,
              let maxTemp = model.list?.first?.main?.temp_max
        else {
             return nil
        }
        let tempDescription = "\(Int(temp))°"
        let tempDetailDescription = "최고: \(Int(maxTemp))° | 최저: \(Int(minTemp))°"
        return .init(city: name, temp: tempDescription, weather: weather, tempDetail: tempDetailDescription)
    }
    
    private func makeSections(_ model: ResponseModel) -> [Section] {
        var sections: [Section] = []
        sections.append(contentsOf: self.makeTodayWeatherSections(model))
        sections.append(contentsOf: self.makeWeatherSections(model))
        sections.append(self.makePrecipitationSection())
        sections.append(self.makeETCSection(model))
        return sections
    }
    
    private func makeTodayWeatherSections(_ model: ResponseModel) -> [Section] {
        guard let list = model.list else { return [] }
        guard let firstDT = list.first?.dt, let now = firstDT.toDate else { return [] }
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
        
        return [.todayWeather([
            .title(titleItem),
            .todayWeather(.init(collectionViewCellModels: items))])
        ]
    }
    
    private func makeWeatherSections(_ model: ResponseModel) -> [Section] {
        guard let list = model.list else { return [] }
        guard let firstDT = list.first?.dt, let now = firstDT.toDate else { return [] }
        let titleItem: MainTitleTableViewCellModel = .init(title: "5일간의 일기예보", style: .secondary)
        let items = (0...5).compactMap { daysBetween -> Item? in
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
        
        return [.fiveDayWeather([.title(titleItem)] + items)]
    }
    
    private func makePrecipitationSection() -> Section {
        return .precipitation(.precipitation(.init(lat: self.currentLocation.lat, lon: self.currentLocation.lon)))
    }
    
    private func makeETCSection(_ model: ResponseModel) -> Section {
        return .etc(.etc(.init(collectionViewCellModels: [
            .init(title: "습도", content: "56%", description: nil),
            .init(title: "구름", content: "50%", description: nil),
            .init(title: "바람 속도", content: "1.97m/s", description: "강풍: 3.39m/s"),
            .init(title: "기압", content: "1,030hpa", description: nil)
        ])))
    }
    
    private var currentLocation: (lat: Double, lon: Double) = (lat: 36.783611, lon: 127.004173)
    private let dateManager = DateManager()
    
    private var headerViewModel: MainHeaderViewModel?
    private var sections: [Section] = []
    private let weatherProvider: MoyaProvider<WeatherAPI>
    private let viewModelEventRelay = PublishRelay<MainViewModelEvent>()
    private let disposeBag = DisposeBag()
    
}
