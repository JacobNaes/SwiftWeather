//
//  Cloud.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/20/22.
//

import SwiftUI

class Cloud {
   enum Thickness: CaseIterable {
      case none, thin, light, regular, thick, ultra
   }
   
   var position: CGPoint
   let imageNumber: Int
   let speed = Double.random(in: 4...12)
   let scale: Double
   
   init(imageNumber: Int, scale: Double) {
      self.imageNumber = imageNumber
      self.scale = scale
      let height = UIScreen.main.bounds.height
      let startX = Double.random(in: -400...400)
      let startY = Double.random(in: -50...height/6)
      position = CGPoint(x: startX, y: startY)
   }
}
