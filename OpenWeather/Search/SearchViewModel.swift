//
//  SearchViewModel.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import Foundation
import RxSwift
import RxRelay

enum SearchViewModelEvent {
    
    case reloadData
    case dismissWithLocation(Location)
    
}

final class SearchViewModel {
    
    typealias ResponseModel = [City.ResponseModel]
    
    enum Section {
        
        case search([Item])
        
        var items: [Item] {
            switch self {
            case .search(let items):        return items
            }
        }
    }
    
    enum Item {
        
        case search(SearchTableViewCellModel, Location)
        
    }
    
    var viewModelEvent: Observable<SearchViewModelEvent> {
        self.viewModelEventRelay.asObservable()
    }
    
    var numberOfSections: Int {
        return self.sections.count
    }
    
    init(cityProvider: LocalProvider<CityAPI>) {
        self.cityProvider = cityProvider
        self.requestCityList()
    }
    
    func search(keyword: String) {
        self.sections = keyword.isEmpty ? self.makeDefaultSections(self.origin) : self.makeSections(self.origin, keyword: keyword)
        self.viewModelEventRelay.accept(.reloadData)
    }
    
    func cellDidSelect(at indexPath: IndexPath) {
        guard let section = self.sections[safe: indexPath.section] else { return }
        guard let item = section.items[safe: indexPath.row] else { return }
        switch item {
        case .search(_, let location):
            self.viewModelEventRelay.accept(.dismissWithLocation(location))
        }
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.sections[safe: section]?.items.count ?? 0
    }
    
    func item(at indexPath: IndexPath) -> Item? {
        guard let section = self.sections[safe: indexPath.section] else { return nil }
        return section.items[safe: indexPath.row]
    }
    
    private func requestCityList() {
        let model: ResponseModel? = self.cityProvider.load(.list)
        self.performAfterFetchingCityList(model)
    }
    
    private func performAfterFetchingCityList(_ model: ResponseModel?) {
        guard let model = model else {
            return
        }
        self.origin = model
        self.sections = self.makeDefaultSections(model)
        self.viewModelEventRelay.accept(.reloadData)
    }
    
    private func makeDefaultSections(_ model: ResponseModel) -> [Section] {
        let items = model
            .compactMap { item -> Item? in
                guard let lat = item.coord?.lat, let lon = item.coord?.lon else { return nil }
                let city = item.name ?? ""
                let country = item.country ?? ""
                return .search(.init(city: city, country: country), .init(lat: lat, lon: lon))
            }
        return [.search(items)]
    }
    
    private func makeSections(_ model: ResponseModel, keyword: String) -> [Section] {
        let items = model
            .compactMap { item -> Item? in
                guard item.name?.contains(keyword) == true else { return nil }
                guard let lat = item.coord?.lat, let lon = item.coord?.lon else { return nil }
                let city = item.name ?? ""
                let country = item.country ?? ""
                return .search(.init(city: city, country: country), .init(lat: lat, lon: lon))
            }
        return [.search(items)]
    }
    
    private var origin: ResponseModel = []
    private var sections: [Section] = []
    
    private let cityProvider: LocalProvider<CityAPI>
    private let viewModelEventRelay = PublishRelay<SearchViewModelEvent>()
    private let disposeBag = DisposeBag()
    
}
