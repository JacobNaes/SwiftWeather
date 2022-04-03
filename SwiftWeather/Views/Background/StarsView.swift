//
//  StarsView.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/20/22.
//

import SwiftUI

struct StarsView: View {
   private let viewModel: StarsViewModel
   
   init(time: Double) {
      viewModel = StarsViewModel(time: time)
   }
   
   var body: some View {
      TimelineView(.animation) { timeLine in
         Canvas { context, size in
            let timeInterval = timeLine.date.timeIntervalSince1970
            viewModel.update(date: timeLine.date)
            context.addFilter(.blur(radius: 0.4))
            
            for (index, star) in viewModel.stars.enumerated() {
               let path = Path(ellipseIn: CGRect(x: star.x, y: star.y, width: star.size, height: star.size))
               
               if star.flickerInterval == 0 {
                  var flashLevel = sin(Double(index) + timeInterval * 4)
                  flashLevel = abs(flashLevel)
                  flashLevel /= 2.5
                  context.opacity = 0.5 + flashLevel
               } else {
                  var flashLevel = sin(Double(index) + timeInterval)
                  flashLevel *= star.flickerInterval
                  flashLevel -= star.flickerInterval - 1
                  
                  if flashLevel > 0 {
                     var contextCopy = context
                     context.opacity = flashLevel
                     contextCopy.addFilter(.blur(radius: 3))
                     
                     context.fill(path, with: .color(white: 1))
                     context.fill(path, with: .color(white: 1))
                     context.fill(path, with: .color(white: 1))
                  }
                  
                  context.opacity = 1
               }
               
               if index.isMultiple(of: 5) {
                  context.fill(path, with: .color(red: 1, green: 0.75, blue: 0.7))
               } else {
                  context.fill(path, with: .color(white: 1))
               }
            }
         }
      }
      .ignoresSafeArea()
      .mask(LinearGradient(colors: [.white, .clear], startPoint: .top, endPoint: .bottom))
      .opacity(viewModel.starOpacity)
   }
}

struct StarsView_Previews: PreviewProvider {
   static var previews: some View {
      StarsView(time: 0.8)
         .background(Color.black)
   }
}
