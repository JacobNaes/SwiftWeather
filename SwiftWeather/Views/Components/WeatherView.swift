//
//  WeatherView.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/31/22.
//

import SwiftUI

struct WeatherView: View {
   private var sectionSpacing: CGFloat = 40
   private let weather: Weather
   
   init(weather: Weather) {
      self.weather = weather
   }
   
   var body: some View {
      ZStack {
         BackgroundView(weather: weather)
            .ignoresSafeArea()
         
         ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: sectionSpacing) {
               WeatherHeaderView(weather: weather)
               WeatherHourlyView(weather: weather)
               WeatherDailyView(weather: weather)
               WeatherDetailView(weather: weather)
            }
            .padding(.top)
            .padding(.horizontal)
         }
      }
      .navigationTitle(weather.location.name)
      .navigationBarTitleDisplayMode(.large)
   }
}

struct WeatherView_Previews: PreviewProvider {
   static var previews: some View {
      NavigationView {
         VStack {
            WeatherView(weather: PreviewManager.exampleWeather)
         }
      }
   }
}
