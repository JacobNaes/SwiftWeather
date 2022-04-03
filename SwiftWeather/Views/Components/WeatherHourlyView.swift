//
//  WeatherHourlyView.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/31/22.
//

import SwiftUI

struct WeatherHourlyView: View {
   private let viewModel: WeatherHourlyViewModel
   
   init(weather: Weather) {
      viewModel = WeatherHourlyViewModel(weather: weather)
   }
   
   var body: some View {
      VStack(alignment: .leading, spacing: nil) {
         Label("48-HOUR FORECAST", systemImage: "clock")
            .font(.system(.subheadline, design: .rounded))
            .foregroundStyle(.secondary)
            .padding([.top, .leading], 10)
         
         Divider()
            .background(Color.primary)
            .padding([.leading, .trailing], 10)
         
         ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 30) {
               ForEach(viewModel.hourColumns) { column in
                  WeatherHourlyStackView(column: column)
               }
            }
            .padding(.trailing)
         }
         .padding(.bottom, 10)
      }
      .background(
         RoundedRectangle(cornerRadius: 12, style: .continuous)
            .foregroundStyle(.thickMaterial)
      )
   }
}

fileprivate struct WeatherHourlyStackView: View {
   let column: HourWeatherColumn
   
   var body: some View {
      VStack(alignment: .center, spacing: 0) {
         Text(column.time)
            .font(.system(.body, design: .rounded))
         Spacer()
         
         WeatherIconView(icon: column.icon, condition: column.conditionType) { icon in
            icon
            .font(.title2)
         }
         
         Spacer()
         Text(column.detail)
            .font(.system(.headline, design: .rounded))
      }
      .offset(x: 10, y: 0)
   }
}

struct WeatherHourlyView_Previews: PreviewProvider {
   static var previews: some View {
      WeatherHourlyView(weather: PreviewManager.exampleWeather)
         .background(Color.gray)
   }
}
