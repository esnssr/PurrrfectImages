//
//  FullView.swift
//  PurrrfectImages
//
//  Created by Eslam Nahel on 2023-09-28.
//

import SwiftUI

struct FullView: View {
    
    @ObservedObject var viewModel = ScreensViewModel()
    var imageSize: MainView.ImageSizes = .small
    
    @State var gridLayout: [GridItem] = [ GridItem(.flexible(), spacing: 16) ]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 16) {
                    ForEach(Array(viewModel.viewData.enumerated()), id: \.1) { index, item in
                        Image(systemName: "photo.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                            .padding(8)
                            .purrrImage(item.urls[imageSize.rawValue])
                            .frame(width: 370, height: 200)
                            .background(.blue.gradient)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .onAppear {
                                if (viewModel.viewData.count - 4) > 0, index == (viewModel.viewData.count - 4) {
                                    Task {
                                        await viewModel.getViewData(limit: 10)
                                    }
                                }
                            }
                    }
                }
                .padding()
            }
        }
        .background(.bar)
        .navigationTitle("Full")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.getViewData(limit: 10)
        }
    }
}

struct FullView_Previews: PreviewProvider {
    static var previews: some View {
        FullView()
    }
}
