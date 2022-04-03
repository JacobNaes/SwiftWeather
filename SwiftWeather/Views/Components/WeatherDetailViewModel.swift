//
//  WeatherDetailViewModel.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 4/2/22.
//

import SwiftUI

extension WeatherDetailView {
   struct WeatherDetailViewModel {
      let feelsLikeTemp: String
      let cloudPercent: String
      let cloudDescription: String
      let windSpeed: String
      let windDirection: String
      let visibility: String
      let pressure: String
      let uvIndex: String
      let humidity: String
      let dewPoint: String
      
      let sunTimeLabel: Label<Text, Image>
      let sunTimeMain: String
      let sunTimeDescription: String
      
      private let weather: Weather
      
      init(weather: Weather) {
         self.weather = weather
         
         feelsLikeTemp = weather.current.feelsLike.formatted()
         cloudPercent = weather.current.clouds.formatted(.percent)
         windSpeed = weather.current.windSpeed.formatted()
         windDirection = weather.current.windDeg.toCardinalDirection() + "º"
         visibility = weather.current.visibility.formatted()
         pressure = weather.current.pressure.formatted()
         uvIndex = weather.current.uvi.rounded().formatted()
         humidity = weather.current.humidity.formatted(.percent)
         dewPoint = weather.current.dewPoint.formatted()
         
         switch weather.current.clouds {
            case 0.11..<0.25:
               cloudDescription = "Few"
            case 0.25..<0.50:
               cloudDescription = "Scattered"
            case 0.50..<0.84:
               cloudDescription = "Broken"
            case 0.84..<1.0:
               cloudDescription = "Overcast"
            default:
               cloudDescription = "Clear"
         }
         
         var sunriseNext: Bool
         var sunrise = weather.daily[0].sunrise
         var sunset = weather.daily[0].sunset
         
         if weather.current.dateTime > sunset {
            sunrise = weather.daily[1].sunrise
            sunset = weather.daily[1].sunset
            sunriseNext = true
         } else if weather.current.dateTime > sunrise {
            sunrise = weather.daily[1].sunrise
            sunriseNext = false
         } else {
            sunriseNext = true
         }
         
         let dateFormatter = DateFormatter()
         dateFormatter.timeZone = self.weather.timeZone
         dateFormatter.dateFormat = "h:m a"
         
         if sunriseNext {
            sunTimeLabel = Label("Sunrise", systemImage: "sunrise")
            sunTimeMain = dateFormatter.string(from: sunrise)
            sunTimeDescription = "Sunset at \(dateFormatter.string(from: sunset))"
         } else {
            sunTimeLabel = Label("Sunset", systemImage: "sunset")
            sunTimeMain = dateFormatter.string(from: sunset)
            sunTimeDescription = "Sunrise at \(dateFormatter.string(from: sunrise))"
         }
      }
   }

}
