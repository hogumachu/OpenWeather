//
//  LocationManager.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/26.
//

import RxSwift
import RxRelay

final class LocationManager {
    
    static let shared = LocationManager()
    
    private init() {
        self.currentLocation = BehaviorSubject<Location>(value: Location(lat: 36.783611, lon: 127.004173))
    }
    
    var currentLocation: BehaviorSubject<Location>
    
}
