//
//  UITableView+Rx.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

extension Reactive where Base: UITableView {
    
    func itemSelected<T>(dataSource: TableViewSectionedDataSource<T>) -> ControlEvent<T.Item> {
        let source = self.itemSelected.map { indexPath in dataSource[indexPath] }
        return ControlEvent(events: source)
    }
    
}
