//
//  UserWeatherStore.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/30/22.
//

import Foundation
import CoreData
import OSLog

class UserWeatherStore: NSObject, ObservableObject {
   @Published private (set) var weather: Weather? = nil
   
   private let logger = Logger(subsystem: "com.jakenaes.SwiftWeather", category: "UserWeatherStore")
   private let repository: WeatherRepository
   private let apiManager = APIManager.shared
   private let fetchedWeatherController: NSFetchedResultsController<WeatherMO>
   
   private static var fetchRequest: NSFetchRequest<WeatherMO> = {
      let request = WeatherMO.fetchRequest()
      request.predicate = NSPredicate(format: "isUserWeather == YES")
      request.sortDescriptors = []
      return request
   }()
   
   private var weatherMO: WeatherMO? {
      let fetchedObjects = fetchedWeatherController.fetchedObjects ?? []
      
      guard fetchedObjects.count <= 1 else {
         fatalError("Should only be one user weather object")
      }
      
      return fetchedObjects.first
   }
   
   private var lastUpdate: Date {
      get {
         UserDefaults.standard.object(forKey: UserDefaults.Keys.userWeather) as! Date
      }
      set {
         UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.userWeather)
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
   
   func update(lat: Double, lon: Double) -> () {
      Task {
         let (weatherData, locationData) = try await apiManager.fetchBoth(lat: lat, lon: lon)
         
         if let weather = weather, let location = locationData.first {
            try await repository.update(id: weather.managedObjectID, weatherData, location, isUsersLocation: true)
            lastUpdate = .now
         } else if let location = locationData.first {
               try await repository.create(weatherData, location, isUserLocation: true)
               lastUpdate = .now
         }
      }
   }
   
   func refreshWeather() {
      if let weather = weather, shouldUpdate {
         update(lat: weather.location.lat, lon: weather.location.lon)
      }
   }
}

extension UserWeatherStore: NSFetchedResultsControllerDelegate {
   private func setupFetchedWeatherController() {
      fetchedWeatherController.delegate = self
      try? fetchedWeatherController.performFetch()
      
      if let weatherMO = weatherMO {
         self.weather = weatherMO.toDomainModel()
      }
   }
   
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      if let weatherMO = weatherMO {
         self.weather = weatherMO.toDomainModel()
      }
   }
}
