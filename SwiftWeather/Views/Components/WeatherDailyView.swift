//
//  WeatherDailyView.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/31/22.
//

import SwiftUI

struct WeatherDailyView: View {
   @ScaledMetric(relativeTo: .body) private var verticalSpacing: CGFloat = 50
   private let weather: Weather
   private let dateFormatter: DateFormatter
   
   init(weather: Weather) {
      let dateFormatter = DateFormatter()
      dateFormatter.timeZone = weather.timeZone
      dateFormatter.dateFormat = "EEEE"
      self.dateFormatter = dateFormatter
      self.weather = weather
   }
   
   var body: some View {
      VStack(alignment: .leading, spacing: nil) {
         Label("8-DAY FORECAST", systemImage: "calendar")
            .font(.system(.subheadline, design: .rounded))
            .foregroundStyle(.secondary)
         
        
         
         VStack(spacing: 1) {
            Divider()
               .background(Color.primary)
            ForEach(weather.daily.indices, id: \.self) { index in
               let dayWeather = weather.daily[index]
               
               HStack(alignment: .center, spacing: nil) {
                  Text(index == 0 ? "Today" : dateFormatter.string(from: dayWeather.day))
                     .font(.system(.title3, design: .rounded))
                     .frame(maxWidth: .infinity, alignment: .leading)
                  
                  WeatherIconView(icon: dayWeather.condition.icon, condition: dayWeather.condition.type) { icon in
                     ZStack {
                        Image(systemName: "cloud.rain")
                           .foregroundColor(.clear)
                           .font(.title2)
                        
                        VStack(spacing: 0) {
                           icon
                              .font(.title2)

//                           if dayWeather.precipitationChance > 0.3 {
//                              Text(dayWeather.precipitationChance.formatted(.percent))
//                                 .foregroundColor(.blue)
//                                 .font(.caption2)
//                           }
                        }
                     }
                  }

                  HStack(alignment: .center, spacing: nil) {
                     Text("↓").foregroundColor(.blue) +
                     Text(dayWeather.tempMin.formatted(.measurement(width: .narrow)))
                     Text("↑").foregroundColor(.red) +
                     Text(dayWeather.tempMax.formatted(.measurement(width: .narrow)))
                  }
                  .font(.system(.headline, design: .rounded))
                  .frame(maxWidth: .infinity, alignment: .trailing)
               }
               .frame(height: verticalSpacing, alignment: .leading)
               
               
               if index != weather.daily.count - 1 {
                  Divider()
                     .background(Color.primary)
               }
            }
         }
      }
      .padding(10)
      .background(
         RoundedRectangle(cornerRadius: 12, style: .continuous)
            .foregroundStyle(.thickMaterial)
      )
   }
}

struct WeatherDailyView_Previews: PreviewProvider {
   static var previews: some View {
      WeatherDailyView(weather: PreviewManager.exampleWeather)
         .background(Color.gray)
         .previewLayout(.sizeThatFits)
   }
}
