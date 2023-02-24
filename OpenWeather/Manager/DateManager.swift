//
//  DateManager.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import Foundation
import Then

final class DateManager {
    
    func day(date: Date) -> Int {
        return self.calednar.component(.day, from: date)
    }
    
    func dayOfWeek(date: Date) -> String {
        return self.dayOfWeekFormatter.string(from: date)
    }
    
    func toHourString(date: Date) -> String {
        return self.dateFormatter.string(from: date)
    }
    
    func daysBetween(from base: Date, to compare: Date) -> Int? {
        return calednar.dateComponents([.day], from: base, to: compare).day
    }
    
    func hoursBetween(from base: Date, to comare: Date) -> Int? {
        return calednar.dateComponents([.hour], from: base, to: comare).hour
    }
    
    private let calednar = Calendar(identifier: .gregorian)
    private lazy var dateFormatter: DateFormatter = {
        return DateFormatter().then {
            $0.locale = Locale(identifier: "ko_kr")
            $0.dateFormat = "a h시"
        }
    }()
    
    private lazy var dayOfWeekFormatter: DateFormatter = {
        return DateFormatter().then {
            $0.locale = Locale(identifier: "ko_kr")
            $0.dateFormat = "E"
        }
    }()
    
}
