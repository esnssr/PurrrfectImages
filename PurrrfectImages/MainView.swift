//
//  MainView.swift
//  PurrrfectImages
//
//  Created by Eslam Nahel on 2023-09-27.
//

import SwiftUI

struct MainView: View {
    
    enum ImageSizes: String, CaseIterable, Identifiable {
        var id: UUID {
            return UUID()
        }
        case raw, full, regular, small, thumb
    }
    
    @State var sizeSelection: ImageSizes = .full
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text("Screens")
                    .font(.largeTitle.bold())
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 24)
                
                VStack(spacing: 16) {
                    NavigationLink {
                        ListView(selectedSize: sizeSelection)
                    } label: {
                        HStack {
                            Image(systemName: "list.bullet.rectangle.portrait.fill")
                                .font(.title2)
                            
                            Text("List")
                                .fontDesign(.rounded)
                                .font(.title.bold())
                        }
                        .frame(maxWidth: .infinity)
                        .padding(24)
                        .foregroundStyle(.white)
                    }
                    .background(.cyan.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(radius: 3)
                    
                    NavigationLink {
                        GridView(selectedSize: sizeSelection)
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.grid.2x2.fill")
                                .font(.title2)
                            
                            Text("Grid")
                                .fontDesign(.rounded)
                                .font(.title.bold())
                        }
                        .frame(maxWidth: .infinity)
                        .padding(24)
                        .foregroundStyle(.white)
                    }
                    .background(.purple.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(radius: 3)

                    NavigationLink {
                        FullView(selectedSize: sizeSelection)
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.grid.1x2.fill")
                                .font(.title2)
                            
                            Text("Full")
                                .fontDesign(.rounded)
                                .font(.title.bold())
                        }
                        .frame(maxWidth: .infinity)
                        .padding(24)
                        .foregroundStyle(.white)
                    }
                    .background(.yellow.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(radius: 3)
                    
                    Spacer()
                }
                
                VStack(spacing: 24) {
                    Text("Image Size")
                        .font(.largeTitle.bold())
                        .fontDesign(.rounded)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack {
                        Picker("Image Size", selection: $sizeSelection) {
                            ForEach(ImageSizes.allCases) { item in
                                Text(item.rawValue.capitalized)
                                    .tag(item)
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(radius: 4)
                    
                }
                .padding(.top, 24)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.bar)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
