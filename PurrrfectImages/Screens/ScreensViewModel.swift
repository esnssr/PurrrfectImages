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
    
    private var purrrfetcher: ImagePrefetcher?
    
    private var nextPage = 1 {
        didSet {
            // limit page numbers to 100 for the demo
            canLoadMore = nextPage != 100
        }
    }
    
    private var canLoadMore = true
    
    private var nextDataBatch = [ImageModel]()
    
    private var lastBatchImageRequests: [ImageRequest] = []
    
    @Published private(set) var viewData = [ImageModel]()
    
    let imagesSize: CGSize
    let selectedSize: MainView.ImageSizes
    
    init(imagesSize: CGSize, selectedSize: MainView.ImageSizes) {
        self.imagesSize = imagesSize
        self.selectedSize = selectedSize
        var pipelineConfiguration: ImagePipeline.Configuration = .withURLCache
        pipelineConfiguration.isProgressiveDecodingEnabled = false
        pipelineConfiguration.isUsingPrepareForDisplay = false
        pipelineConfiguration.isDecompressionEnabled = true
        pipelineConfiguration.isStoringPreviewsInMemoryCache = false
        let pipeline = ImagePipeline(configuration: pipelineConfiguration)
        
        purrrfetcher = ImagePrefetcher(pipeline: pipeline, destination: .diskCache)
        
        purrrfetcher?.didComplete = {
            print("did finish prefetching")
        }
    }
    
    deinit {
        purrrfetcher?.stopPrefetching()
        purrrfetcher = nil
    }
    
    func getViewData(shouldUpdate: Bool = true, limit: Int = 10) async {
        do {
            let images = try await dataService.fetchRandomImages(page: nextPage, limit: limit)
            nextPage += 1
            
            if viewData.isEmpty {
                viewData.append(contentsOf: images)
                // immediately start fetching the next page to prefetch its images
                await getViewData(shouldUpdate: false, limit: limit)
            } else {
                let imagesURLs: [ImageRequest] = images
                    .compactMap({ $0.urls[selectedSize.rawValue ] })
                    .map {
                        var request = ImageRequest(url: $0)
                        /*
                         We need to use the same processors we use
                         in the requests and in the prefetcher.
                         */
                        request.processors = [.resize(size: imagesSize)]
                        return request
                    }
                self.purrrfetcher?.startPrefetching(with: imagesURLs)
                
                
                purrrfetcher?.stopPrefetching(with: lastBatchImageRequests)
                self.lastBatchImageRequests = imagesURLs
                
                // only update if we are requesting the data from the view.
                // this is just to avoid updating the data in the first batch
                if shouldUpdate {
                    viewData.append(contentsOf: nextDataBatch)
                }
                
                nextDataBatch = images
            }
        } catch {
            fatalError("Error getting data \(error)")
        }
    }
}
