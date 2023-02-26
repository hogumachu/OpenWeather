//
//  UIScrollView+Rx.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/26.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    
    var scrollViewWillBeginDecelerating: ControlEvent<Base> {
        let source = delegate.methodInvoked(#selector(UIScrollViewDelegate.scrollViewWillBeginDecelerating(_:))).map { _ in base }
        return ControlEvent(events: source)
    }
    
}
