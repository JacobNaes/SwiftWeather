//
//  StormDrop.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/20/22.
//

import SwiftUI

class StormDrop {
   var x: Double
   var y: Double
   var xScale: Double
   var yScale: Double
   var speed: Double
   var opacity: Double
   var direction: Angle
   var rotation: Angle
   var rotationSpeed: Angle
   
   init(type: StormViewModel.Contents, direction: Angle, speed: Double) {
      self.speed = speed
      
      if type == .snow {
         self.direction = direction + .degrees(.random(in: -15...15))
      } else {
         self.direction = direction
      }
      
      x = Double.random(in: -0.2...1.2)
      y = Double.random(in: -0.2...1.2)
      
      switch type {
         case .snow:
            xScale = Double.random(in: 0.125...1)
            yScale = xScale * Double.random(in: 0.5...1)
            opacity = Double.random(in: 0.2...1)
            rotation = Angle.degrees(Double.random(in: 0...360))
            rotationSpeed = Angle.degrees(Double.random(in: -360...360))
         default:
            xScale = Double.random(in: 0.4...1)
            yScale = xScale
            opacity = Double.random(in: 0.05...0.3)
            rotation = Angle.zero
            rotationSpeed = Angle.zero
      }
   }
}
