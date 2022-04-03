//
//  StormView.swift
//  WeatherBackground
//
//  Created by Jacob Naes on 3/20/22.
//

import SwiftUI

struct StormView: View {
   private let viewModel: StormViewModel
   
   init(weather: Weather) {
      viewModel = StormViewModel(weather: weather)
   }
   
   var body: some View {
      TimelineView(.animation) { timeLine in
         Canvas { context, size in
            viewModel.update(date: timeLine.date, size: size)
            for drop in viewModel.drops {
               var contextCopy = context
               let xPos = drop.x * size.width
               let yPos = drop.y * size.height
               contextCopy.opacity = drop.opacity
               contextCopy.translateBy(x: xPos, y: yPos)
               contextCopy.rotate(by: drop.direction + drop.rotation)
               contextCopy.scaleBy(x: drop.xScale, y: drop.yScale)
               contextCopy.draw(viewModel.image, at: .zero)
            }
         }
      }
   }
}

struct StormView_Previews: PreviewProvider {
   static var previews: some View {
      StormView(weather: PreviewManager.exampleWeather)
         .background(Color.gray)
   }
}
