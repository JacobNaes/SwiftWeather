//
//  WeatherData-Helpers.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/30/22.
//

import Foundation

extension Array where Element == WeatherData.Condition {
   var primary: WeatherData.Condition {
      guard let first = self.first else {
         return WeatherData.Condition.default
      }
      return first
   }
}
