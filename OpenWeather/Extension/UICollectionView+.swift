//
//  UICollectionView+.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit

extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(cell: T.Type) {
        let identifier = String(describing: cell)
        self.register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(cell: T.Type, for indexPath: IndexPath) -> T? {
        let identifier = String(describing: cell)
        return self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T
    }
    
}
