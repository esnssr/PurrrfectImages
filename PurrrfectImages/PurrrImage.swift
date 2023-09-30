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
    private var customPipeline: ImagePipeline {
        var pipelineConfiguration: ImagePipeline.Configuration = .withURLCache
        pipelineConfiguration.isProgressiveDecodingEnabled = true
        pipelineConfiguration.isUsingPrepareForDisplay = false
        pipelineConfiguration.isDecompressionEnabled = true
        pipelineConfiguration.isStoringPreviewsInMemoryCache = false
        let pipeline = ImagePipeline(configuration: pipelineConfiguration)
        return pipeline
    }
        
    var imageUrlString: URL?
    var preferredSize: CGSize?

    func body(content: Content) -> some View {
        if let imageUrlString {
            LazyImage(request: createImageRequest(url: imageUrlString)) { state in
                if let image = state.image {
                    image // Displays the loaded image
                        .resizable() // for some reason, this disables the isProgressiveDecodingEnabled 🤷🏼‍♂️
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
            .pipeline(customPipeline)
            .priority(.high)
        } else {
            content
        }
    }
    
    private func createImageRequest(url: URL) -> ImageRequest {
        var request = ImageRequest(url: url)
        
        if let preferredSize {
            request.processors = [.resize(size: preferredSize)]
        }
        
        return request
    }
}


extension View {
    /// Loads, caches and meows back to you a purrrrfect image 🐾, not in this order :)
    func purrrImage(_ imageUrlString: URL?, preferredSize: CGSize? = nil) -> some View {
        modifier(PurrrImage(imageUrlString: imageUrlString, preferredSize: preferredSize))
    }
}
