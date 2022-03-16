//
//  ContentView.swift
//  WeatherDemo
//
//  Created by Oleksii Horokhov on 11.03.2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        
        ZStack {
            GeometryReader { proxy in
                Image("Clouds")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .ignoresSafeArea()
            .blur(radius: 30)
            
            VStack {
                if !weatherViewModel.weatherModels.isEmpty {
                    TabView {
                        ForEach(weatherViewModel.weatherModels, id: \.self) { model in
                            ScrollView(.vertical, showsIndicators: false) {
                                WeatherView(weatherModel: model)
                                    .frame(maxWidth: .infinity)
                            }
                            .padding(.top, 60)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .ignoresSafeArea(.all, edges: .bottom)
                    
                } else {
                    LoadingView()
                        .frame(width: 100, height: 100)
                }
            }
            .onAppear(perform: weatherViewModel.refresh)
            .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(weatherViewModel: WeatherViewModel(weatherService: WeatherService()))
    }
}
