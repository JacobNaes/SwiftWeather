//
//  WeatherHourlyViewModel.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/31/22.
//

import Foundation
import SwiftUI

extension WeatherHourlyView {
   struct WeatherHourlyViewModel {
      let hourColumns: [HourWeatherColumn]
      
      private let weather: Weather
      
      init(weather: Weather) {
         self.weather = weather
         hourColumns = Self.makeColumns(for: weather)
      }
      
      private static func makeColumns(for weather: Weather) -> [HourWeatherColumn] {
         guard let firstHour = weather.hourly.first else { return [] }
         
         var calendar = Calendar(identifier: .gregorian)
         calendar.timeZone = weather.timeZone
         
         let timeZone = weather.timeZone
         var hourColumns = [HourWeatherColumn]()
         var sunriseIndex = 0
         var sunsetIndex = 0
         
         if weather.daily[0].sunset < firstHour.hour {
            sunriseIndex += 1
            sunsetIndex += 1
         } else if weather.daily[0].sunrise < firstHour.hour {
            sunriseIndex += 1
         }
         
         for i in 0...1 {
            let sunriseColumn = HourWeatherColumn(type: .sunrise, date: weather.daily[sunriseIndex + i].sunrise, timeZone: timeZone)
            let sunsetColumn = HourWeatherColumn(type: .sunset, date: weather.daily[sunsetIndex + i].sunset, timeZone: timeZone)
            hourColumns.append(sunriseColumn)
            hourColumns.append(sunsetColumn)
         }
         
         weather.hourly.forEach {
            let iconName = $0.condition.type.getIconName(isDayTime: $0.isDay)
            let column = HourWeatherColumn(type: .temp($0.temp, icon: iconName, condition: $0.condition.type), date: $0.hour, timeZone: timeZone)
            hourColumns.append(column)
         }
         
         return hourColumns.sorted(by: { $0.date < $1.date })
      }
   }

}
