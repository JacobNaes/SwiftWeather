//
//  WeatherDetailView.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/31/22.
//

import SwiftUI

struct WeatherDetailView: View {
   private let viewModel: WeatherDetailViewModel

   private let cellFrame: CGFloat = (UIScreen.main.bounds.width * 0.5) - 10
   private let columns: [GridItem] = [
      GridItem(.flexible(), spacing: 10, alignment: .center),
      GridItem(.flexible(), spacing: 10, alignment: .center)
   ]
   
   init(weather: Weather) {
      viewModel = WeatherDetailViewModel(weather: weather)
   }
   
   var body: some View {
      LazyVGrid(columns: columns, alignment: .center, spacing: nil, pinnedViews: []) {
         WeatherDetailCell(label: Label("Feels Like", systemImage: "thermometer")) {
            Text(viewModel.feelsLikeTemp)
         }
         
         WeatherDetailCell(label: viewModel.sunTimeLabel) {
            Text(viewModel.sunTimeMain)
         } detail: {
            Text(viewModel.sunTimeDescription)
         }
         
         WeatherDetailCell(label: Label("UV Index", systemImage: "sun.max")) {
            Text(viewModel.uvIndex)
         }
         
         WeatherDetailCell(label: Label("Clouds", systemImage: "cloud")) {
            Text(viewModel.cloudPercent)
         } detail: {
            Text(viewModel.cloudDescription)
         }
         
         WeatherDetailCell(label: Label("Humidity", systemImage: "humidity")) {
            Text(viewModel.humidity)
         } detail: {
            Text("Dew point is \(viewModel.dewPoint) right now")
         }
         
         WeatherDetailCell(label: Label("Wind", systemImage: "wind")) {
            Text(viewModel.windSpeed)
         } detail: {
            Text(viewModel.windDirection)
         }
         
         WeatherDetailCell(label: Label("Visibility", systemImage: "eye")) {
            Text(viewModel.visibility)
         }
         
         WeatherDetailCell(label: Label("Pressure", systemImage: "barometer")) {
            Text(viewModel.pressure)
         }
      }
      .font(.system(.title2, design: .rounded))
   }
}

struct WeatherDetailView_Previews: PreviewProvider {
   static var previews: some View {
      ZStack {
         Color.gray.ignoresSafeArea()
         ScrollView {
            WeatherDetailView(weather: PreviewManager.exampleWeather)
         }
      }
   }
}
