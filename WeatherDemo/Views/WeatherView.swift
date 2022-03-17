//
//  WeatherView.swift
//  WeatherDemo
//
//  Created by Oleksii Horokhov on 14.03.2022.
//

import SwiftUI

/// Preview for
struct WeatherView: View {
    
    var weatherModel: DetailedCityModel
    @State var showModal = false
    
    var body: some View {
        // Here we need to check do we have tomorrow weather model at all.
        // Without it pointless to show something on UI
        // Still can be updated with mocked data
        if let model: ConsolidatedWeatherModel = weatherModel.getTomorrowModel() {
            let temp = model.currentTemperature
            let date = model.applicableDate.toDateWith(format: .short).formatted(.dateTime.month(.wide).day())
            VStack {
                Text("Tomorrow, \(date)")
                    .font(.system(size: 30))
                    .bold()
                
                Text(weatherModel.cityName)
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Text("\(temp.roundDouble()) C°")
                    .font(.system(size: 60))
                
                
                AsyncImage(url: model.iconURL()) { image in
                    image.resizable()
                } placeholder: {
                    Image("Sunny")
                        .resizable()
                }
                .frame(width: 50, height: 50)
                
                Text("\(model.weatherStateName)")
                    .font(.headline)
                    .padding()
                
                Button(action: {
                    showModal.toggle()
                }, label: {
                    Text("Detailed weather")
                        .frame(width: 200, height: 50)
                        .background(Color(hue: 0.524, saturation: 0.726, brightness: 0.533))
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .padding()
                })
            }
            // Here we show weather details in modal window on full screen
            .fullScreenCover(isPresented: $showModal) {
                DetailedWeatherView(weatherModel: weatherModel, tomorrowModel: model)
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weatherModel: previewWeather)
    }
}
