//
//  GridView.swift
//  PurrrfectImages
//
//  Created by Eslam Nahel on 2023-09-27.
//

import SwiftUI

struct GridView: View {
    
    @StateObject var viewModel: ScreensViewModel
    
    init(selectedSize: MainView.ImageSizes = .full) {
        self._viewModel = StateObject(wrappedValue: ScreensViewModel(imagesSize: .init(width: 130, height: 130), selectedSize: selectedSize))
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(Array(viewModel.viewData.enumerated()), id: \.1) { index, item in
                        VStack(alignment: .center) {
                            Image(systemName: "photo.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .padding(8)
                                .purrrImage(item.urls[viewModel.selectedSize.rawValue], preferredSize: .init(width: 130, height: 130))
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 130, height: 130)
                                .background(.blue.gradient)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            
                            Text(item.user.name.capitalized)
                                .font(.title2.bold())
                                .fontDesign(.rounded)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(radius: 5)
                        .onAppear {
                            if (viewModel.viewData.count - 4) > 0, index == (viewModel.viewData.count - 4) {
                                Task {
                                    await viewModel.getViewData(limit: 15)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .background(.bar)
        .navigationTitle("Grid")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.getViewData(limit: 15)
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
    }
}
