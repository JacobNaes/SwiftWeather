//
//  ConditionType.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/29/22.
//

import SwiftUI

enum ConditionType: Int, CaseIterable {
   /// SunTimes
   case sunrise = 1
   case sunset = 2
   
   /// Thunderstorm
   case thunderStormLightRain = 200
   case thunderStormRain = 201
   case thunderStormHeavyRain = 202
   case lightThunderStorm = 210
   case thunderStorm = 211
   case heavyThunderStorm = 212
   case raggedThunderStorm = 221
   case thunderStormLightDrizzle = 230
   case thunderStormDrizzle = 231
   case thunderstormHeavyDrizzle = 232
   
   /// Drizzle
   case lightIntensityDrizzle = 300
   case drizzle = 301
   case heavyIntensityDrizzle = 302
   case lightIntensityDrizzleRain = 310
   case drizzleRain = 311
   case heavyIntensityDrizzleRain = 312
   case showerRainDrizzle = 313
   case heavyShowerRainDrizzle = 314
   case showerDrizzle = 321
   
   /// Rain
   case lightRain = 500
   case moderateRain = 501
   case heavyIntensityRain = 502
   case veryHeavyRain = 503
   case extremeRain = 504
   case freezingRain = 511
   case lightIntensityShowerRain = 520
   case showerRain = 521
   case heavyIntensityShowerRain = 522
   case raggedShowerRain = 531
   
   /// Snow
   case lightSnow = 600
   case snow = 601
   case heavySnow = 602
   case sleet = 611
   case lightShowerSleet = 612
   case showerSleet = 613
   case lightRainSnow = 615
   case rainSnow = 616
   case lightShowerSnow = 620
   case showerSnow = 621
   case heavyShowerSnow = 622
   
   /// Atmosphere
   case mist = 701
   case smoke = 711
   case haze = 721
   case sandDustWhirls = 731
   case fog = 741
   case sand = 751
   case dust = 761
   case volcanicAsh = 762
   case squalls = 771
   case tornado = 781
   
   /// Clear
   case clear = 800
   
   /// Clouds
   case few = 801
   case scattered = 802
   case broken = 803
   case overcast = 804
   
   /// Default
   case `default` = 0
   
   func getIconName(isDayTime: Bool) -> String {
      switch self {
         case .sunrise:
            return "sunrise"
         case .sunset:
            return "sunset"
         case .lightThunderStorm, .thunderStormLightDrizzle:
            return "\(isDayTime ? "cloud.sun.bolt" : "cloud.moon.bolt")"
         case .thunderStorm, .heavyThunderStorm, .raggedThunderStorm:
            return "cloud.bolt"
         case .thunderStormLightRain, .thunderStormRain, .thunderStormHeavyRain, .thunderStormDrizzle, .thunderstormHeavyDrizzle:
            return "cloud.bolt.rain"
         case .lightIntensityDrizzle, .drizzle, .heavyIntensityDrizzle, .lightIntensityDrizzleRain, .drizzleRain, .heavyIntensityDrizzleRain, .showerRainDrizzle, .showerDrizzle, .heavyShowerRainDrizzle:
            return "cloud.drizzle"
         case .lightRain, .moderateRain, .veryHeavyRain, .lightIntensityShowerRain, .showerRain:
            return "cloud.rain"
         case .heavyIntensityRain, .extremeRain, .heavyIntensityShowerRain, .raggedShowerRain:
            return "cloud.heavyrain"
         case .freezingRain:
            return "cloud.hail"
         case .lightSnow, .snow, .heavySnow, .lightRainSnow, .rainSnow, .lightShowerSnow, .showerSnow, .heavyShowerSnow:
            return "cloud.snow"
         case .sleet, .showerSleet, .lightShowerSleet:
            return "cloud.sleet"
         case .mist:
            return "cloud.drizzle"
         case .smoke:
            return "smoke"
         case .haze:
            return "sun.haze"
         case .sandDustWhirls, .sand, .dust, .volcanicAsh:
            return "sun.dust"
         case .fog:
            return "cloud.fog"
         case .squalls, .tornado:
            return "tornado"
         case .clear:
            return "\(isDayTime ? "sun.max" : "moon.stars")"
         case .few, .scattered:
            return "\(isDayTime ? "cloud.sun" : "cloud.moon")"
         case .broken, .overcast:
            return "cloud"
         case .`default`:
            return "thermometer"
      }
   }
}
