//
//  UserWeatherViewModel.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/30/22.
//

import Combine
import Foundation
import CoreLocation
import OSLog

class UserWeatherViewModel: ObservableObject {
   @Published private (set) var weather: Weather?
   
   private let logger = Logger(subsystem: "com.jakenaes.SwiftWeather", category: "UserWeatherViewModel")
   private let weatherStore: UserWeatherStore
   private let locationManager = LocationManager.shared
   private var weatherSubscription: AnyCancellable?
   private var locationSubscription: AnyCancellable?
   
   init(persistenceManager: PersistenceManager) {
      weatherStore = UserWeatherStore(persistenceManager: persistenceManager)
      setupWeatherSubscription()
      setupLocationSubscription()
      refreshWeather()
   }
   
   func refreshWeather() {
      weatherStore.refreshWeather()
   }
   
   private func setupWeatherSubscription() {
      weatherSubscription = weatherStore.$weather.sink { [weak self] weather in
         guard let self = self else { return }
         self.weather = weather
      }
   }
   
   private func setupLocationSubscription() {
      locationSubscription = locationManager.location().sink { [weak self] location in
         guard let self = self else { return }
         guard let newLocation = location else { return }
         
         let lat = newLocation.coordinate.latitude
         let lon = newLocation.coordinate.longitude
         
         if let weather = self.weather {
            let previousLocation = CLLocation(latitude: weather.location.lat, longitude: weather.location.lon)
            let distanceMeters = Measurement(value: previousLocation.distance(from: newLocation), unit: UnitLength.meters)
            if distanceMeters.converted(to: .miles).value > 2 {
               self.logger.debug("Distance is greater than 2 miles -> update")
               self.weatherStore.update(lat: lat, lon: lon)
            }
         } else {
            self.weatherStore.update(lat: lat, lon: lon)
         }
      }
   }
}
