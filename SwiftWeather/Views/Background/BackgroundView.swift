//
//  BackgroundView.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/31/22.
//

import SwiftUI

struct BackgroundView: View {
   private let viewModel: BackgroundViewModel
   private let dateFormatter: DateFormatter
   
   init(weather: Weather) {
      viewModel = BackgroundViewModel(weather: weather)
      dateFormatter = DateFormatter()
      dateFormatter.timeZone = weather.timeZone
      dateFormatter.dateFormat = "E, d MMM, yyyy h:mm a"
   }
   
   var body: some View {
      ZStack {
         StarsView(time: viewModel.time)
         CloudsView(cloudPercent: viewModel.clouds, time: viewModel.time, graySky: viewModel.graySky)
         StormView(weather: viewModel.weather)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(LinearGradient(colors: [viewModel.topTint, viewModel.bottomTint],
                        startPoint: .top,
                        endPoint: .bottom))
   }
}

struct BackgroundView_Previews: PreviewProvider {
   static var previews: some View {
      BackgroundView(weather: PreviewManager.exampleWeather)
   }
}
