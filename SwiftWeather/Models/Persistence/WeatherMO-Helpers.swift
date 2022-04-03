//
//  WeatherMO-Helpers.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/30/22.
//

import Foundation

// MARK: - WeatherMO

extension WeatherMO {
   var locationID: Int {
      Int(locationID_)
   }
   
   var locationName: String {
      locationName_ ?? ""
   }
   
   var locationRegion: String {
      locationRegion_ ?? ""
   }
   
   var locationCountry: String {
      locationCountry_ ?? ""
   }
   
   var current: CurrentWeatherMO {
      current_!
   }
   
   var daily: [DayWeatherMO] {
      daily_?.allObjects as? [DayWeatherMO] ?? []
   }
   
   var hourly: [HourWeatherMO] {
      hourly_?.allObjects as? [HourWeatherMO] ?? []
   }
   
   var timeZone: TimeZone {
      TimeZone(secondsFromGMT: Int(timeOffset)) ?? .autoupdatingCurrent
   }
}


// MARK: - CurrentWeatherMO

extension CurrentWeatherMO {
   var date: Date {
      date_ ?? .now
   }
   
   var sunrise: Date {
      sunrise_ ?? .now
   }
   
   var sunset: Date {
      sunset_ ?? .now
   }
   
   var timeZone: TimeZone {
      TimeZone(secondsFromGMT: Int(timeOffset)) ?? .autoupdatingCurrent
   }
   
   var isDay: Bool {
      date > sunrise && date < sunset
   }
}


// MARK: - DayWeatherMO

extension DayWeatherMO {
   var day: Date {
      day_ ?? .now
   }
   
   var sunrise: Date {
      sunrise_ ?? .now
   }
   
   var sunset: Date {
      sunset_ ?? .now
   }
   
   var moonrise: Date {
      moonrise_!
   }
   
   var moonset: Date {
      moonset_!
   }
   
   var timeZone: TimeZone {
      TimeZone(secondsFromGMT: Int(timeOffset)) ?? .autoupdatingCurrent
   }
}


// MARK: - HourWeatherMO

extension HourWeatherMO {
   var hour: Date {
      hour_ ?? .now
   }
   
   var daySunrise: Date {
      daySunrise_ ?? .now
   }
   
   var daySunset: Date {
      daySunset_ ?? .now
   }
   
   var timeZone: TimeZone {
      TimeZone(secondsFromGMT: Int(timeOffset)) ?? .autoupdatingCurrent
   }
}


// MARK: - WeatherConditionMO

extension WeatherConditionMO {
   var code: Int {
      Int(code_)
   }
   
   var main: String {
      main_ ?? ""
   }
   
   var detail: String {
      detail_ ?? ""
   }
   
   var time: Date {
      time_!
   }
   
   var timeZone: TimeZone {
      TimeZone(secondsFromGMT: Int(timeOffset)) ?? .autoupdatingCurrent
   }
}
