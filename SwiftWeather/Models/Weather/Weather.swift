//
//  Weather.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/29/22.
//

import Foundation
import CoreData
import SwiftUI

// MARK: - Weather

struct Weather: Identifiable {
  var id: NSManagedObjectID { managedObjectID }
   let managedObjectID: NSManagedObjectID
   let location: Location
   let current: CurrentWeather
   let daily: [DayWeather]
   let hourly: [HourWeather]
   let timeZone: TimeZone
   
   init(managedObjectID: NSManagedObjectID, location: Location, current: Weather.CurrentWeather, daily: [Weather.DayWeather], hourly: [Weather.HourWeather], timeZone: TimeZone) {
      self.managedObjectID = managedObjectID
      self.location = location
      self.current = current
      self.daily = daily.sorted(by: { $0.day < $1.day })
      self.hourly = hourly.sorted(by: { $0.hour < $1.hour })
      self.timeZone = timeZone
   }
}


// MARK: - CurrentWeather

extension Weather {
   struct CurrentWeather {
      let clouds: Double
      let dewPoint: Measurement<UnitTemperature>
      let dateTime: Date
      let feelsLike: Measurement<UnitTemperature>
      let humidity: Double
      let pressure: Measurement<UnitPressure>
      let sunrise: Date
      let sunset: Date
      let temp: Measurement<UnitTemperature>
      let uvi: Double
      let visibility: Measurement<UnitLength>
      let condition: WeatherCondition
      let windDeg: Measurement<UnitAngle>
      let windGust: Measurement<UnitSpeed>
      let windSpeed: Measurement<UnitSpeed>
      let timeZone: TimeZone
      
      var isDay: Bool {
         dateTime > sunrise && dateTime < sunset
      }
   }
}


// MARK: - DayWeather

extension Weather {
   struct DayWeather: Identifiable {
      var id: Date { day }
      let clouds: Double
      let dewPoint: Measurement<UnitTemperature>
      let day: Date
      let humidity: Double
      let moonPhase: Double
      let moonrise: Date
      let moonset: Date
      let precipitationChance: Double
      let pressure: Measurement<UnitPressure>
      let sunrise: Date
      let sunset: Date
      let tempMax: Measurement<UnitTemperature>
      let tempMin: Measurement<UnitTemperature>
      let uvi: Double
      let condition: WeatherCondition
      let windDeg: Measurement<UnitAngle>
      let windGust: Measurement<UnitSpeed>
      let windSpeed: Measurement<UnitSpeed>
      let timeZone: TimeZone
      let rain: Measurement<UnitVolume>
      let snow: Measurement<UnitVolume>
   }
}




// MARK: - HourWeather

extension Weather {
   struct HourWeather: Identifiable {
      var id: Date { hour }
      let clouds: Double
      let dewPoint: Measurement<UnitTemperature>
      let hour: Date
      let feelsLike: Measurement<UnitTemperature>
      let humidity: Double
      let pressure: Measurement<UnitPressure>
      let precipitationChance: Double
      let temp: Measurement<UnitTemperature>
      let uvi: Double
      let visibility: Measurement<UnitLength>
      let condition: WeatherCondition
      let windDeg: Measurement<UnitAngle>
      let windGust: Measurement<UnitSpeed>
      let windSpeed: Measurement<UnitSpeed>
      let daySunrise: Date
      let daySunset: Date
      let timeZone: TimeZone
      
      var isDay: Bool {
         hour > daySunrise && hour < daySunset
      }
   }
}


// MARK: - WeatherCondition

extension Weather {
   struct WeatherCondition {
      static let `default` = WeatherCondition(code: 0, main: "", detail: "", time: .now, timeZone: .current, isDay: true)
      
      let code: Int
      let main: String
      let detail: String
      let time: Date
      let timeZone: TimeZone
      let type: ConditionType
      let isDay: Bool
      
      var icon: Image {
         Image(systemName: type.getIconName(isDayTime: isDay))
      }
      
      init(code: Int, main: String, detail: String, time: Date, timeZone: TimeZone, isDay: Bool) {
         self.code = code
         self.main = main
         self.detail = detail
         self.time = time
         self.timeZone = timeZone
         self.type = ConditionType.allCases.first(where: { $0.rawValue == code }) ?? .default
         self.isDay = isDay
      }
   }
}
