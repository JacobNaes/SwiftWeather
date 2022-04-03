//
//  SwiftWeatherApp.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/29/22.
//

import SwiftUI

@main
struct SwiftWeatherApp: App {
   private let persistenceManager = PersistenceManager.shared
   
   init() {
      UserDefaults.standard.register(defaults: [
         UserDefaults.Keys.userWeather: Date.now,
         UserDefaults.Keys.favoriteWeather: Date.now
      ])
   }
   
   var body: some Scene {
      WindowGroup {
         MainTabView(persistenceManager: persistenceManager)
      }
   }
}
