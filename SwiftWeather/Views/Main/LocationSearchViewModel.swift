//
//  LocationSearchViewModel.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/30/22.
//

import Combine
import SwiftUI

class LocationSearchViewModel: ObservableObject {
   @Published private (set) var locations: [LocationData] = []
   @Published var searchText: String = ""
   
   private let apiManager = APIManager.shared
   private let saveAction: (LocationData) -> ()
   private var searchSubscriber: AnyCancellable?
   
   init(saveAction: @escaping (LocationData) -> ()) {
      self.saveAction = saveAction
   }
   
   func save(location: LocationData) {
      saveAction(location)
   }
   
   func getLocations(completion: @escaping () -> Void) {
      guard !self.searchText.isEmpty else {
         locations.removeAll()
         completion()
         return
      }
      
      Task {
         do {
            let locationsData = try await apiManager.fetchLocation(query: self.searchText)
            await MainActor.run {
               self.locations = locationsData
               completion()
            }
         } catch CoreDataError.saveError {
            self.locations.removeAll()
            print(CoreDataError.saveError.localizedDescription)
         } catch {
            print(error.localizedDescription)
         }
      }
   }
}
