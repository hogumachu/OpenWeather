//
//  UITableView+.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit

extension UITableView {
    
    func registerCell<T: UITableViewCell>(cell: T.Type) {
        let identifier = String(describing: cell)
        self.register(cell, forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(cell: T.Type, for indexPath: IndexPath) -> T? {
        let identifier = String(describing: cell)
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T
    }
    
}
