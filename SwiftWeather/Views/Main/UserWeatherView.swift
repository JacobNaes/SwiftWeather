//
//  UserWeatherView.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/29/22.
//

import SwiftUI

struct UserWeatherView: View {
   @StateObject private var viewModel: UserWeatherViewModel
   
   init(persistenceManager: PersistenceManager) {
      let userWeatherViewModel = UserWeatherViewModel(persistenceManager: persistenceManager)
      _viewModel = StateObject(wrappedValue: userWeatherViewModel)
   }
   
   var body: some View {
      NavigationView {
         Group {
            if let weather = viewModel.weather {
               WeatherView(weather: weather)
                  .onAppear {
                     viewModel.refreshWeather()
                  }
            } else {
               Text("No Weather")
            }
         }
      }
   }
}

struct UserWeatherView_Previews: PreviewProvider {
   static var previews: some View {
      TabView {
         UserWeatherView(persistenceManager: .preview)
      }
   }
}
