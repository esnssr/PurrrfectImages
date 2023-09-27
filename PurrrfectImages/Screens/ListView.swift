//
//  ListView.swift
//  PurrrfectImages
//
//  Created by Eslam Nahel on 2023-09-27.
//

import SwiftUI

struct ListView: View {
    
    @ObservedObject var viewModel = ScreensViewModel()
    var imageSize: MainView.ImageSizes = .small
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(Array(viewModel.viewData.enumerated()), id: \.1) { index, item in
                        HStack(spacing: 16) {
                            Image(systemName: "photo.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 32, height: 32)
                                .padding(8)
                                .frame(width: 60, height: 60)
                                .purrrImage(item.urls[imageSize.rawValue])
                                .frame(width: 60, height: 60)
                                .background(.blue.gradient)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            
                            
                            Text(item.user.name.capitalized)
                                .font(.title2.bold())
                                .fontDesign(.rounded)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(.black)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(radius: 3)
                        .onAppear {
                            if (viewModel.viewData.count - 4) > 0, index == (viewModel.viewData.count - 4) {
                                Task {
                                    await viewModel.getViewData(limit: 20)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .background(.bar)
        .navigationTitle("List")
        .task {
            await viewModel.getViewData(limit: 20)
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
