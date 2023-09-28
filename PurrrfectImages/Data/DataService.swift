//
//  DataService.swift
//  PurrrfectImages
//
//  Created by Eslam Nahel on 2023-09-27.
//

import Foundation

class DataService {
    
    private struct Endpoint {
        let path: String
        let queryItems: [URLQueryItem]
        
        var url: URL? {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.unsplash.com"
            components.path = path
            components.queryItems = queryItems
            
            return components.url
        }
    }
    
    // our super secret api key
    private let apiKey = "n7FrU6g5X5saCYxl9IFNDq8OBOgDgMQJqVoLzwMSaw0"
        
    func fetchRandomImages(page: Int, limit: Int = 10) async throws -> [ImageModel] {
        let endpoint = Endpoint(
            path: "/photos",
            queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(limit)"),
                URLQueryItem(name: "client_id", value: apiKey)
            ]
        )
        
        guard let endpointUrl = endpoint.url else {
            fatalError("No url found, what are you doing??")
        }
        
        let (data, response) = try await URLSession.shared.data(from: endpointUrl)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("usuccessful response, just like you apperantly...")
        }
        
        let decodedData = try JSONDecoder().decode([ImageModel].self, from: data)
//        debugPrint("Data is \(decodedData)")
        return decodedData
    }
}
