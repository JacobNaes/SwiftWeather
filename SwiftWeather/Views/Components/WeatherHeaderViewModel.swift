//
//  WeatherHeaderViewModel.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/31/22.
//

import Foundation
import SwiftUI

extension WeatherHeaderView {
   struct WeatherHeaderViewModel {
      let locationName: String
      let conditionIcon: Image
      let conditionType: ConditionType
      let conditionDescription: String
      let temp: String
      let minTemp: String
      let maxTemp: String
      let rainChance: String
      let humidity: String
      let windSpeed: String
      let rainVolume: String
      
      var willRain: Bool {
         guard let hourWeather = weather.hourly.first else { return false }
         
         if hourWeather.precipitationChance > 0.60 {
            return true
         }
         
         return false
      }
      
      private let weather: Weather
      
      init(weather: Weather) {
         self.weather = weather
         locationName = "\(weather.location.name), \(weather.location.region)"
         conditionIcon = weather.current.condition.icon
         conditionType = weather.current.condition.type
         conditionDescription = weather.current.condition.detail.capitalized
         temp = weather.current.temp.formatted(.measurement(width: .narrow))
         minTemp = weather.daily.first?.tempMin.formatted(.measurement(width: .narrow)) ?? ""
         maxTemp = weather.daily.first?.tempMax.formatted(.measurement(width: .narrow)) ?? ""
         rainChance = weather.hourly.first?.precipitationChance.formatted(.percent) ?? ""
         humidity = weather.current.humidity.formatted(.percent)
         windSpeed = weather.current.windSpeed.formatted(.measurement(width: .abbreviated))
         rainVolume = weather.daily.first?.rain.formatted() ?? ""
      }
   }
}
