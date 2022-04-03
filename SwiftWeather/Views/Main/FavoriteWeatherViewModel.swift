//
//  FavoriteWeatherViewModel.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/30/22.
//

import Combine
import Foundation

class FavoriteWeatherViewModel: ObservableObject {
   @Published private (set) var favoriteWeather = [Weather]()
   @Published var showingSearchView: Bool = false
   
   private let weatherStore: FavoriteWeatherStore
   private var weatherSubscriber: AnyCancellable?
   
   init(persistenceManager: PersistenceManager) {
      weatherStore = FavoriteWeatherStore(persistenceManager: persistenceManager)
      setupWeatherSubscriber()
   }
   
   func update() {
      weatherStore.refreshWeather()
   }
   
   func showSearchView() {
      showingSearchView = true
   }
   
   func add(data: LocationData) {
      do {
         try weatherStore.add(locationData: data)
      } catch CoreDataError.saveError {
         print(CoreDataError.saveError.localizedDescription)
      } catch {
         print(error.localizedDescription)
      }
   }
   
   func delete(_ indexSet: IndexSet) {
      do {
        try indexSet.map { favoriteWeather[$0] }.forEach(weatherStore.delete(_:))
      } catch CoreDataError.saveError {
         print(CoreDataError.saveError)
      } catch {
         print(error.localizedDescription)
      }
   }
   
   func delete(_ weather: Weather) {
      do {
         try weatherStore.delete(weather)
      } catch CoreDataError.saveError {
         print(CoreDataError.saveError)
      } catch {
         print(error.localizedDescription)
      }
   }

   private func setupWeatherSubscriber() {
      weatherSubscriber = weatherStore.$weatherFavorites.sink { [weak self] savedWeather in
         guard let self = self else { return }
         self.favoriteWeather = savedWeather
      }
   }
}
