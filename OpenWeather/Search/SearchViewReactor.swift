//
//  SearchViewReactor.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import Foundation
import RxSwift
import ReactorKit

final class SearchViewReactor: Reactor {
    
    typealias ResponseModel = [City.ResponseModel]
    
    enum Action {
        
        case refresh
        case textUpdate(keyword: String?)
        case itemSelectAt(indexPath: IndexPath)
        
    }
    
    enum Mutation {
        
        case reloadData
        case search(keyword: String)
        case updateLocation(indexPath: IndexPath)
        
    }
    
    struct State {
        
        var origin: ResponseModel
        var sections: [SearchSection]
        var currentLocation: Location?
        
    }
    
    let initialState: State = State(origin: [], sections: [], currentLocation: nil)
    
    init(cityProvider: LocalProvider<CityAPI>) {
        self.cityProvider = cityProvider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            let reloadData = Observable<Mutation>.just(.reloadData)
            return reloadData
            
        case .textUpdate(let keyword):
            let search = Observable<Mutation>.just(.search(keyword: keyword ?? ""))
            return search
            
        case .itemSelectAt(let indexPath):
            let updateLocation = Observable<Mutation>.just(.updateLocation(indexPath: indexPath))
            return updateLocation
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .reloadData:
            if let model = self.requestCityList() {
                newState.origin = model
                newState.sections = self.makeDefaultSections(model)
            }
            
        case .search(let keyword):
            newState.sections = keyword.isEmpty ? self.makeDefaultSections(state.origin) : self.makeSections(state.origin, keyword: keyword)
            
        case .updateLocation(let indexPath):
            if let section = state.sections[safe: indexPath.section], let item = section.items[safe: indexPath.row] {
                switch item {
                case .search(_, let location):
                    newState.currentLocation = location
                    LocationManager.shared.currentLocation.onNext(location)
                }
            }
        }
        
        return newState
    }
    
    private func requestCityList() -> ResponseModel? {
        let model: ResponseModel? = self.cityProvider.load(.list)
        return model
    }
    
    private let cityProvider: LocalProvider<CityAPI>
    private let disposeBag = DisposeBag()
    
}

extension SearchViewReactor {
    
    // MARK: - Generate Sections
    
    private func makeDefaultSections(_ model: ResponseModel) -> [SearchSection] {
        let items = model
            .compactMap { item -> SearchItem? in
                guard let lat = item.coord?.lat, let lon = item.coord?.lon else { return nil }
                let city = item.name ?? ""
                let country = item.country ?? ""
                return .search(.init(city: city, country: country), .init(lat: lat, lon: lon))
            }
        return [.init(items: items)]
    }
    
    private func makeSections(_ model: ResponseModel, keyword: String) -> [SearchSection] {
        let items = model
            .compactMap { item -> SearchItem? in
                guard item.name?.contains(keyword) == true else { return nil }
                guard let lat = item.coord?.lat, let lon = item.coord?.lon else { return nil }
                let city = item.name ?? ""
                let country = item.country ?? ""
                return .search(.init(city: city, country: country), .init(lat: lat, lon: lon))
            }
        return [.init(items: items)]
    }
    
}
