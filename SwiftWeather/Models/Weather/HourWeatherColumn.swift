//
//  HourWeatherColumn.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/31/22.
//

import SwiftUI

struct HourWeatherColumn: Identifiable {
   enum ColumnType {
      case temp(_ hourTemp: Measurement<UnitTemperature>, icon: String, condition: ConditionType)
      case sunrise, sunset
   }
   
   let id = UUID()
   let time: String
   let icon: Image
   let detail: String
   let date: Date
   let conditionType: ConditionType
   
   init(type: ColumnType, date: Date, timeZone: TimeZone) {
      self.date = date
      
      let dateFormatter = DateFormatter()
      dateFormatter.timeZone = timeZone
      
      switch type {
         case .temp(let temp, let iconName, let condition):
            dateFormatter.dateFormat = "ha"
            time = dateFormatter.string(from: date)
            icon = Image(systemName: iconName)
            detail = temp.formatted(.measurement(width: .narrow))
            conditionType = condition
            
         case .sunrise:
            dateFormatter.dateFormat = "h:mma"
            time = dateFormatter.string(from: date)
            icon = Image(systemName: "sunrise")
            detail = "sunrise"
            conditionType = .sunrise
         case .sunset:
            dateFormatter.dateFormat = "h:mma"
            time = dateFormatter.string(from: date)
            icon = Image(systemName: "sunset")
            detail = "sunset"
            conditionType = .sunset
      }
   }
}
