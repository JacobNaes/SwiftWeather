//
//  LocationManager.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/30/22.
//

import Combine
import CoreLocation
import OSLog

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
   static let shared = LocationManager()
   
   private let logger = Logger(subsystem: "com.jakenaes.SwiftWeather", category: "LocationManager")
   private var locationPublisher: CurrentValueSubject<CLLocation?, Never> = CurrentValueSubject(nil)
   private let manager = CLLocationManager()
   
   private override init() {
      super.init()
      manager.delegate = self
      manager.pausesLocationUpdatesAutomatically = false
      manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
      manager.startUpdatingLocation()
   }
   
   static func getPlaceMark(for location: CLLocation) async throws -> CLPlacemark {
      let geocoder = CLGeocoder()
      let placeMarks = try await geocoder.reverseGeocodeLocation(location)
      guard let placeMark = placeMarks.first else { throw CLError(.geocodeFoundNoResult) }
      return placeMark
   }
   
   func location() -> AnyPublisher<CLLocation?, Never> {
      return locationPublisher.eraseToAnyPublisher()
   }
   
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let newLocation = locations.last else { return }
      if shouldUpdateLocation(to: newLocation) {
         locationPublisher.send(newLocation)
      }
   }
   
   func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
      switch manager.authorizationStatus {
         case .notDetermined:
            logger.debug("Not Determined")
            manager.requestWhenInUseAuthorization()
         case .restricted:
            logger.debug("Restricted")
            break
         case .denied:
            logger.debug("Denied")
            locationPublisher.send(nil)
         case .authorizedAlways:
            logger.debug("Authorized Always")
            break
         case .authorizedWhenInUse:
            logger.debug("Authorized When In Use")
            break
         @unknown default:
            logger.warning("Unknown Authorization")
      }
   }
   
   private func shouldUpdateLocation(to location: CLLocation) -> Bool {
      guard let lastKnownLocation = locationPublisher.value else { return true }
      let distanceInMeters = Measurement(value: lastKnownLocation.distance(from: location), unit: UnitLength.meters)
      let distanceInMiles = distanceInMeters.converted(to: .miles)
      if distanceInMiles.value > 2 { return true }
      return false
   }
}

