//
//  PersistenceManager.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/29/22.
//

import CoreData

struct PersistenceManager {
   static let shared = PersistenceManager()
   
   let container: NSPersistentContainer
   
   init(inMemory: Bool = false) {
      container = NSPersistentContainer(name: "SwiftWeather")
      
      if inMemory {
         container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
      }
      
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
         if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
         }
      })
      
      container.viewContext.automaticallyMergesChangesFromParent = true
   }
   
   static var preview: PersistenceManager = {
      var persistenceManager = PersistenceManager(inMemory: true)
      let viewContext = persistenceManager.container.viewContext
      persistenceManager.makeWeather(PreviewManager.exampleWeatherData, PreviewManager.exampleLocationsData.first!, in: viewContext)
//      do {
//         try viewContext.save()
//      } catch {
//         let nsError = error as NSError
//         fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//      }
      return persistenceManager
   }()
}

 extension PersistenceManager {
    @discardableResult
    private func makeWeather(_ weatherData: WeatherData, _ locationData: LocationData, in context: NSManagedObjectContext) -> WeatherMO {
       let viewContext = context
       let weatherData = PreviewManager.exampleWeatherData
       let locationData = PreviewManager.exampleLocationsData.first!
       
       let weatherMO = WeatherMO(context: viewContext)
       
       let currentMO = CurrentWeatherMO(context: viewContext)
       currentMO.weather = weatherMO
       currentMO.condition_ = WeatherConditionMO(context: viewContext)
       
       for _ in weatherData.daily {
          let dayWeatherMO = DayWeatherMO(context: viewContext)
          dayWeatherMO.weather = weatherMO
          dayWeatherMO.condition_ = WeatherConditionMO(context: viewContext)
       }
       
       for _ in weatherData.hourly {
          let hourWetherMO = HourWeatherMO(context: viewContext)
          hourWetherMO.weather = weatherMO
          hourWetherMO.condition_ = WeatherConditionMO(context: viewContext)
       }
       
       weatherMO.update(weatherData: weatherData, locationData: locationData, usersLocation: true)
       return weatherMO
    }
}
