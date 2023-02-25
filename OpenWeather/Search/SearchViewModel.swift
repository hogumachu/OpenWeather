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
        
        case search(SearchTableViewCellModel)
        
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
            .map { item -> Item in
                return .search(.init(city: item.name ?? "", country: item.country ?? ""))
            }
        return [.search(items)]
    }
    
    private func makeSections(_ model: ResponseModel, keyword: String) -> [Section] {
        let items = model
            .compactMap { item -> Item? in
                guard item.name?.contains(keyword) == true else { return nil }
                return .search(.init(city: item.name ?? "", country: item.country ?? ""))
            }
        return [.search(items)]
    }
    
    private var origin: ResponseModel = []
    private var sections: [Section] = []
    
    private let cityProvider: LocalProvider<CityAPI>
    private let viewModelEventRelay = PublishRelay<SearchViewModelEvent>()
    private let disposeBag = DisposeBag()
    
}
