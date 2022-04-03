//
//  StarsViewModel.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 4/1/22.
//

import SwiftUI

class StarsViewModel {
   var stars = [Star]()
   let leftEdge = -50.0
   let rightEdge = 500.0
   var lastUpdate = Date.now
   let time: Double
   
   var starOpacity: Double {
      let color = starStops.interpolated(amount: time)
      return color.getComponents().alpha
   }
   
   let starStops: [Gradient.Stop] = [
      .init(color: .white, location: 0),
      .init(color: .white, location: 0.25),
      .init(color: .clear, location: 0.33),
      .init(color: .clear, location: 0.38),
      .init(color: .clear, location: 0.7),
      .init(color: .clear, location: 0.78),
      .init(color: .white, location: 0.82),
      .init(color: .white, location: 1)
   ]
   
   init(time: Double) {
      self.time = time
      
      for _ in 1...200 {
         let x = Double.random(in: leftEdge...rightEdge)
         let y = Double.random(in: 0...600)
         let size = Double.random(in: 1...3)
         let star = Star(x: x, y: y, size: size)
         stars.append(star)
      }
   }
   
   func update(date: Date) {
      let delta = date.timeIntervalSince1970 - lastUpdate.timeIntervalSince1970
      
      for star in stars {
         star.x -= delta * 2
         
         if star.x < leftEdge {
            star.x = rightEdge
         }
      }
      
      lastUpdate = date
   }
}
