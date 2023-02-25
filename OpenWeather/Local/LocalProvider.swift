//
//  LocalProvider.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/25.
//

import Foundation

final class LocalProvider<Target: LocalTarget> {
    
    func load<Response: Decodable>(_ target: Target) -> Response? {
        guard let data = self.fileData(target) else { return nil }
        let response = try? JSONDecoder().decode(Response.self, from: data)
        return response
    }
    
    private func fileData(_ target: Target) -> Data? {
        guard let fileLocation = Bundle.main.url(forResource: target.resource, withExtension: target.withExtension) else { return nil }
        return try? Data(contentsOf: fileLocation)
    }
    
}
