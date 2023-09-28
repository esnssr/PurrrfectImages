//
//  PurrrImage.swift
//  PurrrfectImages
//
//  Created by Eslam Nahel on 2023-09-27.
//

import SwiftUI
import NukeUI
import Nuke


private struct PurrrImage: ViewModifier {
    private var customPipline: ImagePipeline {
        var piplineConfiguration: ImagePipeline.Configuration = .withURLCache
        piplineConfiguration.isProgressiveDecodingEnabled = true
        piplineConfiguration.isUsingPrepareForDisplay = false
        piplineConfiguration.isDecompressionEnabled = true
        piplineConfiguration.isStoringPreviewsInMemoryCache = false
        let pipline = ImagePipeline.init(configuration: piplineConfiguration)
        return pipline
    }
        
    var imageUrlString: URL?
    var preferedSize: CGSize?

    func body(content: Content) -> some View {
        if let imageUrlString {
            LazyImage(request: createImageRequest(url: imageUrlString)) { state in
                if let image = state.image {
                    image // Displays the loaded image
                } else if state.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.white.gradient)
                        .foregroundStyle(.white)
                    
                } else if state.error != nil {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .padding(8)
                        .frame(width: 60, height: 60)
                        .background(.red.gradient)
                }
            }
            .pipeline(customPipline)
        } else {
            content
        }
    }
    
    private func createImageRequest(url: URL) -> ImageRequest {
        var request = ImageRequest(url: url)
        
        if let preferedSize {
            
            request.processors = [.resize(size: preferedSize)]
        }
        
        return request
    }
}


extension View {
    /// Loads, caches and meows back to you a purrrrfect image 🐾, not in this order :)
    func purrrImage(_ imageUrlString: URL?, preferedSize: CGSize? = nil) -> some View {
        modifier(PurrrImage(imageUrlString: imageUrlString, preferedSize: preferedSize))
    }
}
