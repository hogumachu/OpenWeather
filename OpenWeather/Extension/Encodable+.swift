//
//  Encodable+.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import Foundation

extension Encodable {
    
    func jsonData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
    
    func parameters() -> [String: Any] {
        guard let jsonData = try? self.jsonData() else { return [:] }
        let params = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        return params ?? [:]
    }
    
}
