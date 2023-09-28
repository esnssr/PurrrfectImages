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
            // limit page numbers to 50 for the demo
            canLoadMore = nextPage != 50
        }
    }
    
    private var canLoadMore = true
    
    private var nextDataBatch = [ImageModel]()
    
    private var lastBatchImageRequests: [ImageRequest] = []
    
    @Published private(set) var viewData = [ImageModel]()
    
    
    init() {
        var piplineConfiguration: ImagePipeline.Configuration = .withURLCache
        piplineConfiguration.isProgressiveDecodingEnabled = false
        piplineConfiguration.isUsingPrepareForDisplay = false
        piplineConfiguration.isDecompressionEnabled = true
        piplineConfiguration.isStoringPreviewsInMemoryCache = false
        let pipline = ImagePipeline.init(configuration: piplineConfiguration)
        
        purrrfetcher = ImagePrefetcher(destination: .diskCache)
        
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
                await getViewData(shouldUpdate: false, limit: limit)
            } else {
                /*
                 1: stop prefetching the last batch, we are now going to present it
                    the display modifier will take over now
                 */
                purrrfetcher?.stopPrefetching(with: lastBatchImageRequests)
                
                // Start prefetching the next batch
                let imagesURLs: [ImageRequest] = images
                    .compactMap({ $0.urls.full })
                    .map {
                        var requst = ImageRequest(url: $0)
                        requst.processors = [.rsize(size: .init(width: 130, height: 130))]
                        return requst
                    }
                
                self.lastBatchImageRequests = imagesURLs
                self.purrrfetcher?.startPrefetching(with: imagesURLs)
                
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
