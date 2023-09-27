//
//  ScreensViewModel.swift
//  PurrrfectImages
//
//  Created by Eslam Nahel on 2023-09-27.
//

import Foundation

@MainActor
class ScreensViewModel: ObservableObject {
    
    private let dataService = DataService()
    
    private var nextPage = 1
    
    @Published private(set) var viewData = [ImageModel]()
    
    func getViewData(limit: Int = 10) async {
        do {
            let images = try await dataService.fetchRandomImages(page: nextPage, limit: limit)
            viewData.append(contentsOf: images)
            nextPage += 1
        } catch {
            fatalError("Error getting data \(error)")
        }
    }
}
