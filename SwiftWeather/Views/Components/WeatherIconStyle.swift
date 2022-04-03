//
//  WeatherIconStyle.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/31/22.
//

import SwiftUI

extension View {
   func weatherIconStyle(condition: ConditionType) -> some View {
      modifier(WeatherIconStyle(weatherType: condition))
         .symbolVariant(.fill)
         .symbolRenderingMode(.palette)
   }
}

fileprivate struct WeatherIconStyle: ViewModifier {
   let weatherType: ConditionType
   
   func body(content: Content) -> some View {
      switch weatherType {
         case .sunrise, .sunset:
            content.foregroundStyle(.primary, .yellow)
         case .lightThunderStorm, .thunderStormLightDrizzle:
            content.foregroundStyle(.white, .yellow)
         case .thunderStorm, .heavyThunderStorm, .raggedThunderStorm:
            content.foregroundStyle(.white, .yellow)
         case .thunderStormLightRain, .thunderStormRain, .thunderStormHeavyRain, .thunderStormDrizzle, .thunderstormHeavyDrizzle:
            content.foregroundStyle(.white, .blue)
         case .lightIntensityDrizzle, .drizzle, .heavyIntensityDrizzle, .lightIntensityDrizzleRain, .drizzleRain, .heavyIntensityDrizzleRain, .showerRainDrizzle, .showerDrizzle, .heavyShowerRainDrizzle:
            content.foregroundStyle(.white, .blue)
         case .lightRain, .moderateRain, .veryHeavyRain, .lightIntensityShowerRain, .showerRain:
            content.foregroundStyle(.white, .blue)
         case .heavyIntensityRain, .extremeRain, .heavyIntensityShowerRain, .raggedShowerRain:
            content.foregroundStyle(.white, .blue)
         case .freezingRain:
            content.foregroundStyle(.white, .blue)
         case .lightSnow, .snow, .heavySnow, .lightRainSnow, .rainSnow, .lightShowerSnow, .showerSnow, .heavyShowerSnow:
            content.foregroundStyle(.white, .white)
         case .sleet, .showerSleet, .lightShowerSleet:
            content.foregroundStyle(.white, .blue)
         case .mist:
            content.foregroundStyle(.white, .blue)
         case .smoke:
            content.foregroundStyle(.white)
         case .haze:
            content.foregroundStyle(.white, .yellow)
         case .sandDustWhirls, .sand, .dust, .volcanicAsh:
            content.foregroundStyle(.white, .yellow)
         case .fog:
            content.foregroundStyle(.white, .white)
         case .squalls, .tornado:
            content.foregroundStyle(.white)
         case .clear:
            content.foregroundStyle(.yellow)
         case .few, .scattered:
            content.foregroundStyle(.white, .yellow)
         case .broken, .overcast:
            content.foregroundStyle(.white)
         case .`default`:
            content.foregroundStyle(.white)
      }
   }
}
