//
//  ScreensViewModel.swift
//  PurrrfectImages
//
//  Created by Eslam Nahel on 2023-09-27.
//

import Foundation
import Nuke

@MainActor
class ScreensViewModel: ObservableObject {
    
    private let dataService = DataService()
    
    private var nextPage = 1 {
        didSet {
            // limit page numbers to 100 for the demo
            canLoadMore = nextPage != 100
        }
    }
    
    private var canLoadMore = true
    
    @Published private(set) var viewData = [ImageModel]()
    
    let selectedSize: MainView.ImageSizes
    
    init(selectedSize: MainView.ImageSizes) {
        self.selectedSize = selectedSize
    }
    
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
