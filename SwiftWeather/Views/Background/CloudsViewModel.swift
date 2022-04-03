//
//  CloudsViewModel.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/31/22.
//

import SwiftUI

class CloudsViewModel: ObservableObject {
   @Published private (set) var clouds = [Cloud]()
   @Published private (set) var opacity: Double = 0.0
   @Published private (set) var lastUpdate = Date.now
   let topTint: Color
   let bottomTint: Color
   let percentThroughDay: Double
   
   let darkSky: Bool
   
   init(cloudPercent: Double, time: Double, graySky: Bool) {
      let cloudCoverage = cloudPercent
      let cloudThickness: Cloud.Thickness
      self.darkSky = graySky
      switch cloudCoverage {
         case 0.0:
            cloudThickness = .none
         case ..<20:
            cloudThickness = .thin
         case 20..<40:
            cloudThickness = .light
         case 40..<60:
            cloudThickness = .regular
         case 60..<80:
            cloudThickness = .thick
         case 80...100:
            cloudThickness = .ultra
         default:
            cloudThickness = .none
      }
      
      percentThroughDay = time
      
      if graySky {
         topTint = stormTopStops.interpolated(amount: percentThroughDay)
         bottomTint = stormBottomStops.interpolated(amount: percentThroughDay)
      } else {
         topTint = cloudTopStops.interpolated(amount: percentThroughDay)
         bottomTint = cloudBottomStops.interpolated(amount: percentThroughDay)
      }
      
      makeClouds(thickness: cloudThickness)
   }
   
   private let stormTopStops: [Gradient.Stop] = [
      .init(color: .darkCloudStart, location: 0),
      .init(color: .darkCloudStart, location: 0.25),
      .init(color: .stormCloudStart, location: 0.33),
      .init(color: .stormCloudStart, location: 0.38),
      .init(color: .stormCloudStart, location: 0.7),
      .init(color: .stormCloudStart, location: 0.78),
      .init(color: .darkCloudStart, location: 0.82),
      .init(color: .darkCloudStart, location: 1)
   ]
   
   private let stormBottomStops: [Gradient.Stop] = [
      .init(color: .darkCloudEnd, location: 0),
      .init(color: .darkCloudEnd, location: 0.25),
      .init(color: .stormCloudEnd, location: 0.33),
      .init(color: .stormCloudEnd, location: 0.38),
      .init(color: .stormCloudEnd, location: 0.7),
      .init(color: .stormCloudEnd, location: 0.78),
      .init(color: .darkCloudEnd, location: 0.82),
      .init(color: .darkCloudEnd, location: 1)
   ]
   
   private let cloudTopStops: [Gradient.Stop] = [
      .init(color: .darkCloudStart, location: 0),
      .init(color: .darkCloudStart, location: 0.25),
      .init(color: .sunriseCloudStart, location: 0.33),
      .init(color: .lightCloudStart, location: 0.38),
      .init(color: .lightCloudStart, location: 0.7),
      .init(color: .sunsetCloudStart, location: 0.78),
      .init(color: .darkCloudStart, location: 0.82),
      .init(color: .darkCloudStart, location: 1)
   ]
   
   private let cloudBottomStops: [Gradient.Stop] = [
      .init(color: .darkCloudEnd, location: 0),
      .init(color: .darkCloudEnd, location: 0.25),
      .init(color: .sunriseCloudEnd, location: 0.33),
      .init(color: .lightCloudEnd, location: 0.38),
      .init(color: .lightCloudEnd, location: 0.7),
      .init(color: .sunsetCloudEnd, location: 0.78),
      .init(color: .darkCloudEnd, location: 0.82),
      .init(color: .darkCloudEnd, location: 1)
   ]
      
   func update(date: Date) {
      let delta = date.timeIntervalSince1970 - lastUpdate.timeIntervalSince1970
      
      for cloud in clouds {
         cloud.position.x -= delta * cloud.speed
         let offScreenDistance = max(400, 400 * cloud.scale)
         
         if cloud.position.x < -offScreenDistance {
            cloud.position.x = offScreenDistance
         }
      }
      
      lastUpdate = date
   }
   
   private func makeClouds(thickness: Cloud.Thickness) {
      let cloudsToCreate: Int
      let cloudScale: ClosedRange<Double>
      
      switch thickness {
         case .none:
            cloudsToCreate = 0
            opacity = 1
            cloudScale = 1...1
         case .thin:
            cloudsToCreate = 10
            opacity = 0.6
            cloudScale = 0.2...0.4
         case .light:
            cloudsToCreate = 10
            opacity = 0.7
            cloudScale = 0.4...0.6
         case .regular:
            cloudsToCreate = 20
            opacity = 0.8
            cloudScale = 0.7...0.9
         case .thick:
            cloudsToCreate = 30
            opacity = 0.9
            cloudScale = 0.9...1.1
         case .ultra:
            cloudsToCreate = 40
            opacity = 1
            cloudScale = 1.0...1.1
      }
      
      for i in 0..<cloudsToCreate {
         let scale = Double.random(in: cloudScale)
         let imageNumber = i % 8
         let cloud = Cloud(imageNumber: imageNumber, scale: scale)
         clouds.append(cloud)
      }
   }
}
