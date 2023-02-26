//
//  SearchSection.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/25.
//

import RxDataSources

struct SearchSection {
    
    var items: [SearchItem]
    
}

enum SearchItem {
    
    case search(SearchTableViewCellModel, Location)
    
}

extension SearchSection: SectionModelType {
    
    init(original: SearchSection, items: [SearchItem]) {
        self = original
        self.items = items
    }
    
}
