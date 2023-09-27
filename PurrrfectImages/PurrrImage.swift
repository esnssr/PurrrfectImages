//
//  PurrrImage.swift
//  PurrrfectImages
//
//  Created by Eslam Nahel on 2023-09-27.
//

import SwiftUI
import NukeUI

private struct PurrrImage: ViewModifier {
    var imageUrlString: URL?
    
    func body(content: Content) -> some View {
        if let imageUrlString {
            LazyImage(url: imageUrlString) { state in
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
        } else {
            content
        }
    }
}


extension View {
    /// Loads, caches and meows back to you a purrrrfect image 🐾, not in this order :)
    func purrrImage(_ imageUrlString: URL?) -> some View {
        modifier(PurrrImage(imageUrlString: imageUrlString))
    }
}
