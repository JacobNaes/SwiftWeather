//
//  FavoriteWeatherView.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/29/22.
//

import SwiftUI

struct FavoriteWeatherView: View {
   @Environment(\.colorScheme) private var colorScheme
   @StateObject private var viewModel: FavoriteWeatherViewModel
   
   init(persistenceManager: PersistenceManager) {
      let favoriteWeatherViewModel = FavoriteWeatherViewModel(persistenceManager: persistenceManager)
      _viewModel = StateObject(wrappedValue: favoriteWeatherViewModel)
   }
   
   var body: some View {
      NavigationView {
         ZStack {
            LinearGradient(
               colors: [.blueBackground, .lightBackground],
               startPoint: .top,
               endPoint: .bottom
            )
            .edgesIgnoringSafeArea([.top, .bottom])
            
            List {
               ForEach(viewModel.favoriteWeather) { weather in
                  FavoriteWeatherRow(weather: weather) { weather in
                     viewModel.delete(weather)
                  }
               }
               .onDelete(perform: viewModel.delete(_:))
               .listRowBackground(Color.clear)
               .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
         }
         .sheet(isPresented: $viewModel.showingSearchView, onDismiss: nil) {
            LocationSearchView(saveAction: viewModel.add(data:))
         }
         .navigationBarTitle("Favorites")
         .navigationBarTitleDisplayMode(.automatic)
         .toolbar {
            ToolbarItem(placement: .primaryAction) {
               Button(action: viewModel.showSearchView) {
                  Image(systemName: "magnifyingglass")
                     .foregroundColor(.white)
               }
            }
         }
         .onAppear {
            print("Apprear")
            viewModel.update()
         }
      }
   }
}

fileprivate
struct FavoriteWeatherRow: View {
   let weather: Weather
   let deleteAction: (Weather) -> ()
   
   var body: some View {
      NavigationLink(destination: WeatherView(weather: weather)) {
         HStack {
            VStack(alignment: .leading, spacing: nil) {
               Text(weather.location.name + ", " + weather.location.region)
                  .lineLimit(1)
               Text(weather.location.country)
            }
            
            Spacer()
            
            HStack(alignment: .center, spacing: nil) {
               Label {
                  Text(weather.current.temp.formatted(.measurement(width: .narrow)))
               } icon: {
                  WeatherIconView(icon: weather.current.condition.icon, condition: weather.current.condition.type) { $0.font(.title3) }
               }
            }
         }
         .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
               deleteAction(weather)
            } label: {
               Label("Delete", systemImage: "trash")
            }
         }
      }
      .padding()
      .background(
         RoundedRectangle(cornerRadius: 12, style: .continuous)
            .foregroundStyle(.thinMaterial)
      )
   }
}


struct FavoriteWeatherView_Previews: PreviewProvider {
   static var previews: some View {
      FavoriteWeatherView(persistenceManager: .preview)
   }
}
