//
//  BackgroundViewModel.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/31/22.
//

import SwiftUI

class BackgroundViewModel {
   let weather: Weather
   var time: Double
   let topTint: Color
   let bottomTint: Color
   var graySky: Bool
   
   var clouds: Double {
      weather.current.clouds * 100
   }
   
   init(weather: Weather) {
      self.weather = weather
      
      var calendar = Calendar(identifier: .gregorian)
      calendar.timeZone = weather.timeZone
      
      let currentTime = weather.current.dateTime
      let startSeconds = calendar.startOfDay(for: currentTime).timeIntervalSince1970
      let currentSeconds = currentTime.timeIntervalSince1970
      
      time = (currentSeconds - startSeconds) / 86400
      
      switch weather.current.condition.type.rawValue {
         case 200...232:
            graySky = true
         case 300...321:
            graySky = true
         case 500...531:
            graySky = true
         case 804:
            graySky = true
         default:
            graySky = false
      }
      
      if graySky {
         topTint = stormTopStops.interpolated(amount: time)
         bottomTint = stormBottomStops.interpolated(amount: time)
      } else {
         topTint = clearTopStops.interpolated(amount: time)
         bottomTint = clearBottomStops.interpolated(amount: time)
      }
   }
   
   private let stormTopStops: [Gradient.Stop] = [
      .init(color: .stormNightStart, location: 0),
      .init(color: .stormNightStart, location: 0.25),
      .init(color: .stormMorningStart, location: 0.33),
      .init(color: .stormDayStart, location: 0.38),
      .init(color: .stormDayStart, location: 0.7),
      .init(color: .stormEveningStart, location: 0.78),
      .init(color: .stormNightStart, location: 0.82),
      .init(color: .stormNightStart, location: 1)
   ]
   
   private let stormBottomStops: [Gradient.Stop] = [
      .init(color: .stormNighEnd, location: 0),
      .init(color: .stormNighEnd, location: 0.25),
      .init(color: .stormMorningEnd, location: 0.33),
      .init(color: .stormDayEnd, location: 0.38),
      .init(color: .stormDayEnd, location: 0.7),
      .init(color: .stormEveningEnd, location: 0.78),
      .init(color: .stormNighEnd, location: 0.82),
      .init(color: .stormNighEnd, location: 1)
   ]
   
   private let clearTopStops: [Gradient.Stop] = [
      .init(color: .midnightStart, location: 0),
      .init(color: .midnightStart, location: 0.25),
      .init(color: .sunriseStart, location: 0.33),
      .init(color: .sunnyDayStart, location: 0.38),
      .init(color: .sunnyDayStart, location: 0.7),
      .init(color: .sunsetStart, location: 0.78),
      .init(color: .midnightStart, location: 0.82),
      .init(color: .midnightStart, location: 1)
   ]
   
   private let clearBottomStops: [Gradient.Stop] = [
      .init(color: .midnightEnd, location: 0),
      .init(color: .midnightEnd, location: 0.25),
      .init(color: .sunriseEnd, location: 0.33),
      .init(color: .sunnyDayEnd, location: 0.38),
      .init(color: .sunnyDayEnd, location: 0.7),
      .init(color: .sunsetEnd, location: 0.78),
      .init(color: .midnightEnd, location: 0.82),
      .init(color: .midnightEnd, location: 1)
   ]
}
