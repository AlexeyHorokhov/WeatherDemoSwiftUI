//
//  DetailedWeatherView.swift
//  WeatherDemo
//
//  Created by Oleksii Horokhov on 15.03.2022.
//

import SwiftUI

struct DetailedWeatherView: View {
    
    @Environment(\.presentationMode) var presentation
    
    var weatherModel: DetailedCityModel
    var tomorrowModel: ConsolidatedWeatherModel
    
    var body: some View {
        let sunrise = weatherModel.sunrise.toDateWith(format: .long).formatted(.dateTime.hour().minute())
        let sunset = weatherModel.sunset.toDateWith(format: .long).formatted(.dateTime.hour().minute())
        
        ZStack {
            GeometryReader { proxy in
                Image("Clouds")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .ignoresSafeArea()
            .blur(radius: 30)
            ScrollView(.vertical, showsIndicators: false) {
                
                ZStack(alignment: .bottomTrailing) {
                    Button(action: {
                        presentation.wrappedValue.dismiss()
                    }, label: {
                        Text("Close")
                    })
                        .font(.title2)
                        .foregroundColor(.blue)
                        .frame(alignment: .top)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
                
                VStack {
                    CollectionDayItem(detailedModels: weatherModel.consolidatedWeatherModels)
                        .padding()
                    
                    VStack(alignment: .center, spacing: 20) {
                        
                        Text("\(weatherModel.cityName)")
                            .bold()
                            .font(.largeTitle)
                            .padding(.bottom)
                        
                        HStack {
                            DetailComponent(logo: "thermometer.sun.fill",
                                            name: "Min temp",
                                            value: ("\(tomorrowModel.minTemperature.roundDouble()) C°"))
                            Spacer()
                            DetailComponent(logo: "thermometer.sun.fill",
                                            name: "Max temp",
                                            value: ("\(tomorrowModel.maxTemperature.roundDouble()) C°"))
                                .padding(.trailing)
                        }
                        
                        HStack {
                            DetailComponent(logo: "wind",
                                            name: "Wind speed",
                                            value: ("\(tomorrowModel.windSpeed.roundDouble()) m/s"))
                            Spacer()
                            DetailComponent(logo: "humidity",
                                            name: "Humidity",
                                            value: ("\(tomorrowModel.humidity)%"))
                                .padding(.trailing)
                        }
                        
                        HStack {
                            DetailComponent(logo: "thermometer",
                                            name: "Air pressure",
                                            value: ("\(tomorrowModel.airPressure.roundDouble()) mbar"))
                            Spacer()
                            DetailComponent(logo: "aqi.low",
                                            name: "Visibility",
                                            value: ("\(tomorrowModel.visibility.roundDouble()) m"))
                                .padding(.trailing)
                        }
                        HStack {
                            DetailComponent(logo: "sunrise.fill",
                                            name: "Sun rise",
                                            value: sunrise)
                            Spacer()
                            DetailComponent(logo: "sunset",
                                            name: "Sun set",
                                            value: sunset)
                        }
                    }
                    .padding()
                    .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
        }
    }
}

struct DetailedWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedWeatherView(weatherModel: previewWeather, tomorrowModel: previewWeather.consolidatedWeatherModels[0])
    }
}
