//
//  MainTabView.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/29/22.
//

import SwiftUI

struct MainTabView: View {
   
   @State var showTabBar: Bool = false
   private let persistenceManager: PersistenceManager
   
   init(persistenceManager: PersistenceManager) {
      self.persistenceManager = persistenceManager
      setNavBar()
      setTabBar()
   }
   
   var body: some View {
      TabView {
         UserWeatherView(persistenceManager: persistenceManager)
            .tabItem {
               Label("Current", systemImage: "location")
            }
         
         FavoriteWeatherView(persistenceManager: persistenceManager)
            .tabItem {
               Label("Favorites", systemImage: "heart")
            }
      }
   }
   
   private func setNavBar() {
      let color = Color.white
      
      let standardAppearance = UINavigationBarAppearance()
      standardAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
      standardAppearance.backgroundColor = UIColor.clear
      standardAppearance.titleTextAttributes = [.font: UIFont.standardNavigationBarFont, .foregroundColor: UIColor(color)]
      standardAppearance.largeTitleTextAttributes = [.font: UIFont.standardNavigationBarFont, .foregroundColor: UIColor(color)]
      
      let scrollEdgeAppearance = UINavigationBarAppearance()
      scrollEdgeAppearance.configureWithTransparentBackground()
      scrollEdgeAppearance.shadowColor = .clear
      scrollEdgeAppearance.titleTextAttributes = [.font: UIFont.standardNavigationBarFont, .foregroundColor: UIColor(color)]
      scrollEdgeAppearance.largeTitleTextAttributes = [.font: UIFont.largeNavigationBarFont, .foregroundColor: UIColor(color)]
      
      UINavigationBar.appearance().standardAppearance = standardAppearance
      UINavigationBar.appearance().scrollEdgeAppearance = scrollEdgeAppearance
   }
   
   
   private func setTabBar() {
      let tabBarAppearance = UITabBarAppearance()
      tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
      tabBarAppearance.backgroundColor = .clear
      UITabBar.appearance().standardAppearance = tabBarAppearance
      UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
   }
}

struct MainTabView_Previews: PreviewProvider {
   static var previews: some View {
      MainTabView(persistenceManager: .preview)
   }
}
