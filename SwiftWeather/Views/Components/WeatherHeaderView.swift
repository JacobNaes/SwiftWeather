//
//  WeatherHeaderView.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/31/22.
//

import SwiftUI

struct WeatherHeaderView: View {
   @ScaledMetric(relativeTo: .title3) private var tempFont: CGFloat = 70
   @ScaledMetric(relativeTo: .title3) private var degreeFontSize: CGFloat = 30
   @ScaledMetric(relativeTo: .title3) private var degreeOffset: CGFloat = -10
   private let spacing: CGFloat = 5
   private let viewModel: WeatherHeaderViewModel
   
   init(weather: Weather) {
      viewModel = WeatherHeaderViewModel(weather: weather)
   }
   
   var body: some View {
      HStack(alignment: .center, spacing: nil) {
         VStack(alignment: .leading, spacing: spacing) {
            conditionView
            extremeTemperatures
            windView
            moistureView
         }
         .font(.system(.title3, design: .rounded))
         .font(.system(.body, design: .rounded))
         .frame(maxWidth: .infinity, alignment: .leading)
         
         currentTemperature
      }
      .padding(10)
      .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
            .foregroundStyle(.thickMaterial))
   }
}

extension WeatherHeaderView {
   private var conditionView: some View {
      Label {
         Text(viewModel.conditionDescription)
      } icon: {
         WeatherIconView(icon: viewModel.conditionIcon, condition: viewModel.conditionType) {
            $0
         }
      }
   }
   
   private var extremeTemperatures: some View {
      Label {
         HStack(alignment: .center, spacing: nil) {
            Text("↓").foregroundColor(.blue) + Text(viewModel.minTemp)
            Text("↑").foregroundColor(.red) + Text(viewModel.maxTemp)
         }
      } icon: {
         ZStack {
            Image(systemName: "wind")
               .foregroundStyle(.clear)
            Image(systemName: "thermometer")
               .symbolRenderingMode(.palette)
               .symbolVariant(.fill)
               .foregroundStyle(.primary, .red)
         }
      }
   }
   
   private var windView: some View {
      Label(viewModel.windSpeed, systemImage: "wind")
   }
   
   @ViewBuilder
   private var moistureView: some View {
      if viewModel.willRain {
         rainView
      } else {
         humidityView
      }
   }
   
   private var rainView: some View {
      Label {
         Text(viewModel.rainChance)
      } icon: {
         Image(systemName: "drop.circle.fill")
            .symbolRenderingMode(.palette)
            .symbolVariant(.fill)
            .foregroundStyle(.blue, .white)
      }
   }
   
   private var humidityView: some View {
      Label {
         Text(viewModel.humidity)
      } icon: {
         Image(systemName: "humidity")
            .symbolRenderingMode(.palette)
            .symbolVariant(.fill)
            .foregroundStyle(.blue, .primary)
      }
   }
   
   private var currentTemperature: some View {
         Text(viewModel.temp)
            .font(.system(size: tempFont, weight: .medium, design: .rounded))
   }
}

struct WeatherHeaderView_Previews: PreviewProvider {
   static var previews: some View {
      WeatherHeaderView(weather: PreviewManager.exampleWeather)
         .background(Color.gray)
   }
}
