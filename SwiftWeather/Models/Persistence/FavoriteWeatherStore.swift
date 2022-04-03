//
//  FavoriteWeatherStore.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/30/22.
//

import Foundation
import CoreData
import OSLog

class FavoriteWeatherStore: NSObject, ObservableObject {
   @Published private (set) var weatherFavorites = [Weather]()
   
   private let logger = Logger(subsystem: "com.jakenaes.SwiftWeather", category: "FavoriteWeatherStore")
   private let repository: WeatherRepository
   private let apiManager = APIManager.shared
   private let fetchedWeatherController: NSFetchedResultsController<WeatherMO>
   
   private static var fetchRequest: NSFetchRequest<WeatherMO> = {
      let request = WeatherMO.fetchRequest()
      request.predicate = NSPredicate(format: "isUserWeather == NO")
      request.sortDescriptors = [
         NSSortDescriptor(keyPath: \WeatherMO.locationName_, ascending: true)
      ]
      return request
   }()
   
   private var fetchedWeatherMOs: [WeatherMO] {
      fetchedWeatherController.fetchedObjects ?? []
   }
   
   private var lastUpdate: Date {
      get {
         UserDefaults.standard.object(forKey: UserDefaults.Keys.favoriteWeather) as! Date
      }
      set {
         UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.favoriteWeather)
      }
   }
   
   private var shouldUpdate: Bool {
      if abs(lastUpdate.timeIntervalSinceNow) > repository.updateInterval {
         return true
      }
      return false
   }
   
   init(persistenceManager: PersistenceManager) {
      repository = WeatherRepository(persistenceManager: persistenceManager)
      fetchedWeatherController = NSFetchedResultsController(
         fetchRequest: Self.fetchRequest,
         managedObjectContext: persistenceManager.container.viewContext,
         sectionNameKeyPath: nil,
         cacheName: nil)
      
      super.init()
      setupFetchedWeatherController()
   }
   
   func add(locationData: LocationData) throws {
      let locationExists = weatherFavorites.contains(where: {
         $0.location.lat == locationData.lat &&
         $0.location.lon == locationData.lon &&
         $0.location.name == locationData.name
      })
      
      guard !locationExists else { return }
      
      Task {
         let weatherData = try await apiManager.fetchWeather(lat: locationData.lat, lon: locationData.lon)
         try await repository.create(weatherData, locationData, isUserLocation: false)
      }
   }
   
   func delete(_ weather: Weather) throws {
      let weatherMO = fetchedWeatherMOs.first(where: {
         $0.objectID == weather.managedObjectID
      })
      
      guard let weatherMO = weatherMO else { return }
      
      Task {
         try await repository.delete(id: weatherMO.objectID)
      }
   }
   
   func refreshWeather() {
      if shouldUpdate {
         logger.debug("Refreshing")
         Task {
            do {
               let favoriteLocations = weatherFavorites.map { $0.location }
               let allData = try await fetchAllData(for: favoriteLocations)
               try await updateAllWeather(weatherFavorites, with: allData)
               lastUpdate = .now
            } catch {
               fatalError()
            }
         }
      }
   }
   
   private func fetchAllData(for locations: [Location]) async throws -> [(weatherData: WeatherData, locationData: LocationData)] {
      return try await withThrowingTaskGroup(of: (WeatherData, LocationData).self) { group -> [(WeatherData, LocationData)] in
         for location in locations {
            group.addTask {
               let weatherData = try await self.apiManager.fetchWeather(lat: location.lat, lon: location.lon)
               
               let locationData = LocationData(
                  id: location.id,
                  name: location.name,
                  region: location.region,
                  country: location.country,
                  lat: location.lat,
                  lon: location.lon)
               
               return (weatherData, locationData)
            }
         }
         
         var results = [(WeatherData, LocationData)]()
         
         for try await value in group {
            results.append(value)
         }
         
         return results
      }
   }
   
   private func updateAllWeather(_ storedWeather: [Weather], with data: [(weatherData: WeatherData, locationData: LocationData)]) async throws {
      for weather in storedWeather {
         let matchingData = data.first(where: {
            $0.locationData.lat == weather.location.lat &&
            $0.locationData.lon == weather.location.lon &&
            $0.locationData.name == weather.location.name
         })
         
         if let matchingData = matchingData {
            print("Updating")
            try await repository.update(
               id: weather.managedObjectID,
               matchingData.weatherData,
               matchingData.locationData,
               isUsersLocation: false
            )
         }
      }
   }
}

extension FavoriteWeatherStore: NSFetchedResultsControllerDelegate {
   private func setupFetchedWeatherController() {
      fetchedWeatherController.delegate = self
      try? fetchedWeatherController.performFetch()
      
      weatherFavorites = fetchedWeatherMOs.map {
         print("\($0.locationName): \($0.latitude), \($0.longitude)")
         return $0.toDomainModel()
      }
   }
   
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      weatherFavorites = fetchedWeatherMOs.map {
         print("\($0.locationName): \($0.latitude), \($0.longitude)")
         return $0.toDomainModel()
      }
   }
}
