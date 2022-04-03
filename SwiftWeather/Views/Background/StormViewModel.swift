//
//  StormViewModel.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 4/1/22.
//

import SwiftUI

class StormViewModel {
   enum Contents: CaseIterable {
      case none, rain, snow
   }
   
   var drops = [StormDrop]()
   var lastUpdate = Date.now
   var image: Image
   
   init(weather: Weather) {
      let condition = weather.current.condition
      
      let strength: Int
      let direction: Angle
      let speed: Range<Double>
      let type: Contents
      
      switch condition.type.rawValue {
         case 200...531:
            image = Image("rain")
            type = .rain
         case 600...622:
            image = Image("snow")
            type = .snow
         default:
            image = Image(systemName: "car")
            type = .none
      }
      
      switch condition.type {
         case .lightSnow, .lightShowerSnow, .snow:
            strength = 400
            direction = Angle(degrees: 30)
            speed = 0.1..<0.5
            
         case .heavySnow, .heavyShowerSnow, .showerSnow:
            strength = 600
            direction = Angle(degrees: 40)
            speed = 0.4..<0.7
            
         case .thunderStormLightRain, .thunderStormLightDrizzle, .lightRain, .showerDrizzle:
            strength = 100
            direction = Angle(degrees: 5)
            speed = 0.6..<0.8
            
         case .moderateRain, .lightIntensityDrizzle, .showerRainDrizzle, .lightIntensityDrizzleRain, .lightShowerSleet, .lightIntensityShowerRain, .drizzle:
            strength = 300
            direction = Angle(degrees: 10)
            speed = 0.6..<1.0
            
         case .drizzleRain, .showerRain, .sleet, .showerSleet, .lightRainSnow, .rainSnow, .freezingRain, .thunderStormRain, .thunderStormDrizzle:
            strength = 400
            direction = Angle(degrees: 20)
            speed = 0.6..<1.3
            
         case .heavyIntensityDrizzle, .thunderstormHeavyDrizzle, .heavyIntensityDrizzleRain, .heavyShowerRainDrizzle:
            strength = 500
            direction = Angle(degrees: 35)
            speed = 0.6..<1.0
            
         case .extremeRain, .veryHeavyRain, .raggedShowerRain, .heavyIntensityRain, .heavyIntensityShowerRain, .thunderStormHeavyRain:
            strength = 700
            direction = Angle(degrees: 40)
            speed = 0.8..<1.3
            
         default:
            strength = 0
            direction = Angle(degrees: 0)
            speed = 0.0..<0.0
      }
      
   
      for _ in 0..<strength {
         drops.append(StormDrop(type: type,direction: direction + .degrees(90), speed: Double.random(in: speed)))
      }
   }
   
   
   func update(date: Date, size: CGSize) {
      let delta = date.timeIntervalSince1970 - lastUpdate.timeIntervalSince1970
      let divisor = size.height / size.width
      
      for drop in drops {
         let radians = drop.direction.radians
         drop.x += cos(radians) * drop.speed * delta * divisor
         drop.y += sin(radians) * drop.speed * delta
         
         if drop.x < -0.2 {
            drop.x += 1.4
         }
         
         if drop.y > 1.2 {
            drop.x = Double.random(in: -0.2...1.2)
            drop.y -= 1.4
         }
      }
      
      lastUpdate = date
   }
}
