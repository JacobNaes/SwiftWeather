//
//  WeatherRepository.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/30/22.
//

import CoreData
import Foundation

class WeatherRepository {
   let updateInterval = TimeInterval(6 * 1)
   
   private let persistenceManager: PersistenceManager
   
   private lazy var backgroundContext: NSManagedObjectContext = {
      let newContext = persistenceManager.container.newBackgroundContext()
      return newContext
   }()
   
   init(persistenceManager: PersistenceManager) {
     self.persistenceManager = persistenceManager
   }
   
   func create(_ weatherData: WeatherData, _ locationData: LocationData, isUserLocation: Bool) async throws {
      try await backgroundContext.perform {
         let context = self.backgroundContext
         
         let weatherMO = WeatherMO(context: context)
         
         let currentMO = CurrentWeatherMO(context: context)
         let conditionMO = WeatherConditionMO(context: context)
         currentMO.weather = weatherMO
         currentMO.condition_ = conditionMO
         
         for _ in weatherData.daily {
            let dayWeatherMO = DayWeatherMO(context: context)
            let conditionMO = WeatherConditionMO(context: context)
            dayWeatherMO.weather = weatherMO
            dayWeatherMO.condition_ = conditionMO
         }
         
         for _ in weatherData.hourly {
            let hourWeatherMO = HourWeatherMO(context: context)
            let conditionMO = WeatherConditionMO(context: context)
            hourWeatherMO.weather = weatherMO
            hourWeatherMO.condition_ = conditionMO
         }
         
         weatherMO.update(weatherData: weatherData, locationData: locationData, usersLocation: isUserLocation)
         
         do {
            try self.backgroundContext.save()
         } catch {
            throw CoreDataError.saveError
         }
      }
   }
   
   func update(id: NSManagedObjectID, _ weatherData: WeatherData, _ locationData: LocationData, isUsersLocation: Bool) async throws {
      try await backgroundContext.perform {
         let managedObject = try self.backgroundContext.existingObject(with: id)
         
         guard let weatherMO = managedObject as? WeatherMO else {
            throw CoreDataError.invalidObject
         }
         
         weatherMO.update(weatherData: weatherData, locationData: locationData, usersLocation: isUsersLocation)
         
         do {
            try self.backgroundContext.save()
         } catch {
            throw CoreDataError.saveError
         }
      }
   }
   
   func delete(id: NSManagedObjectID) async throws {
      try await backgroundContext.perform {
         let managedObject = try self.backgroundContext.existingObject(with: id)
         
         guard let weatherMO = managedObject as? WeatherMO else {
            throw CoreDataError.invalidObject
         }
         
         self.backgroundContext.delete(weatherMO)
         
         do {
            try self.backgroundContext.save()
         } catch {
            throw CoreDataError.saveError
         }
      }
   }
}
