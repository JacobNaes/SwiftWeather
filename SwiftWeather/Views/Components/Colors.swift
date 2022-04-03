//
//  Colors.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 4/2/22.
//

import SwiftUI

extension Color {
   static let midnightStart = Color(hue: 0.66, saturation: 0.8, brightness: 0.1)
   static let midnightEnd = Color(hue: 0.62, saturation: 0.5, brightness: 0.33)
   static let sunriseStart = Color(hue: 0.62, saturation: 0.6, brightness: 0.42)
   static let sunriseEnd = Color(hue: 0.95, saturation: 0.35, brightness: 0.66)
   static let sunnyDayStart = Color(hue: 0.6, saturation: 0.6, brightness: 0.6)
   static let sunnyDayEnd = Color(hue: 0.6, saturation: 0.4, brightness: 0.85)
   static let sunsetStart = Color.sunriseStart
   static let sunsetEnd = Color(hue: 0.05, saturation: 0.34, brightness: 0.65)
   
   
   static let darkCloudStart = Color(hue: 0.65, saturation: 0.3, brightness: 0.1)
   static let darkCloudEnd = Color(hue: 0.65, saturation: 0.3, brightness: 0.6)
   static let lightCloudStart = Color.white
   static let lightCloudEnd = Color(white: 0.75)
   static let sunriseCloudStart = Color.lightCloudStart
   static let sunriseCloudEnd = Color.sunriseEnd
   static let sunsetCloudStart = Color.lightCloudStart
   static let sunsetCloudEnd = Color.sunsetEnd
   
   static let stormCloudStart = Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
   static let stormCloudEnd = Color(#colorLiteral(red: 0.3327487245, green: 0.3327487245, blue: 0.3327487245, alpha: 1))
   
   
   static let stormMorningStart = Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
   static let stormMorningEnd = Color(#colorLiteral(red: 0.1056504206, green: 0.130445908, blue: 0.1685533588, alpha: 1))
   
   static let stormDayStart = Color(#colorLiteral(red: 0.564550832, green: 0.564550832, blue: 0.564550832, alpha: 1))
   static let stormDayEnd = Color(#colorLiteral(red: 0.2794096808, green: 0.2832341442, blue: 0.271264869, alpha: 1))
   
   static let stormEveningStart = Color(#colorLiteral(red: 0.564550832, green: 0.564550832, blue: 0.564550832, alpha: 1))
   static let stormEveningEnd = Color(#colorLiteral(red: 0.2794096808, green: 0.2832341442, blue: 0.271264869, alpha: 1))
   
   static let stormNightStart = Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
   static let stormNighEnd = Color(#colorLiteral(red: 0.05468715753, green: 0.05973855526, blue: 0.07299638606, alpha: 1))
   
   
   static let lightBackground = Color("lightBackground")
   static let blueBackground = Color("blueBackground")
   
   
   func getComponents() -> (red: Double, green: Double, blue: Double, alpha: Double) {
      var red: CGFloat = 0
      var green: CGFloat = 0
      var blue: CGFloat = 0
      var alpha: CGFloat = 0
      let uiColor = UIColor(self)
      uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
      return (red, green, blue, alpha)
   }
   
   func interpolated(to other: Color, amount: Double) -> Color {
      let componentsFrom = self.getComponents()
      let componentsTo = other.getComponents()
      let newRed = (1 - amount) * componentsFrom.red + (amount * componentsTo.red)
      let newGreen = (1 - amount) * componentsFrom.green + (amount * componentsTo.green)
      let newBlue = (1 - amount) * componentsFrom.blue + (amount * componentsTo.blue)
      let newOpacity = (1 - amount) * componentsFrom.alpha + (amount * componentsTo.alpha)
      return Color(.displayP3, red: newRed, green: newGreen, blue: newBlue, opacity: newOpacity)
   }
}


extension Array where Element == Gradient.Stop {
   func interpolated(amount: Double) -> Color {
      guard let initialStop = self.first else {
         fatalError("Attempted to read color from empty array")
      }
      
      var firstStop = initialStop
      var secondStop = initialStop
      
      for stop in self {
         if stop.location < amount {
            firstStop = stop
         } else {
            secondStop = stop
            break
         }
      }
      
      let totalDifference = secondStop.location - firstStop.location
      
      if totalDifference > 0 {
         let relativeDifference = (amount - firstStop.location) / totalDifference
         return firstStop.color.interpolated(to: secondStop.color, amount: relativeDifference)
      } else {
         return firstStop.color.interpolated(to: secondStop.color, amount: 0)
      }
   }
}
