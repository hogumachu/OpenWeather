//
//  MainSection.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/25.
//

import RxDataSources

struct MainSection {
    
    var items: [MainItem]
    
}

enum MainItem {
    
    case header(MainHeaderTableViewCellModel)
    case title(MainTitleTableViewCellModel)
    case todayWeather(MainTodayWeatherCollectionTableViewCellModel)
    case weather(MainWeatherTableViewCellModel)
    case precipitation(MainPrecipitationTableViewCellModel)
    case etc(MainETCTCollectionTableViewCellModel)
    
}

extension MainSection: SectionModelType {
    
    init(original: MainSection, items: [MainItem]) {
        self = original
        self.items = items
    }
    
}
