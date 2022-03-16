//
//  CollectionDayItem.swift
//  WeatherDemo
//
//  Created by Oleksii Horokhov on 16.03.2022.
//

import SwiftUI

struct CollectionDayItem: View {
    
    var detailedModels: [ConsolidatedWeatherModel]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(detailedModels) { model in
                    let temp = String(model.currentTemperature.roundDouble()) + " C°"
                    let date = model.applicableDate.toDateWith(format: .short).formatted(.dateTime.month(.wide).day())
                    let details = model.weatherStateName
                    let iconUrl = model.iconURL()
                    getDayView(date: date, icon: iconUrl, state: details, temp: temp)
                }
            }
        }
    }
    
    private func getDayView(date: String, icon: URL?, state: String, temp: String) -> some View {
        VStack(spacing: 20) {
            Text(date)
            AsyncImage(url: icon)
            Text(state)
            Text(temp)
        }
        .frame(width: 100)
        .foregroundColor(.white)
        .padding()
        .background(RoundedRectangle(cornerRadius: 5)
                        .fill(LinearGradient(gradient: Gradient(colors: [.yellow, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .blur(radius: 5))
        .shadow(color: Color.white.opacity(0.1), radius: 2, x: -2, y: -2)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 2, y: 2)
    }
}

struct CollectionDayItem_Previews: PreviewProvider {
    static var previews: some View {
        CollectionDayItem(detailedModels: previewWeather.consolidatedWeatherModels)
    }
}
