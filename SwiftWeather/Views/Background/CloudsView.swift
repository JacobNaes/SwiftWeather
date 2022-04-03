//
//  CloudsView.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/20/22.
//

import SwiftUI

struct CloudsView: View {
   @ObservedObject private var viewModel: CloudsViewModel
   
   init(cloudPercent: Double, time: Double, graySky: Bool) {
      _viewModel = ObservedObject(wrappedValue: CloudsViewModel(cloudPercent: cloudPercent, time: time, graySky: graySky))
   }
   
   var body: some View {
      TimelineView(.animation) { timeLine in
         Canvas { context, size in
            viewModel.update(date: timeLine.date)
            context.opacity = viewModel.opacity
            
            let resolvedImages = (0..<8).map { i -> GraphicsContext.ResolvedImage in
               let sourceImage = Image("cloud\(i)")
               var resolved = context.resolve(sourceImage)
               
               resolved.shading = .linearGradient(
                  Gradient(colors: [viewModel.topTint, viewModel.bottomTint]),
                  startPoint: .zero,
                  endPoint: CGPoint(x: 0, y: resolved.size.height)
               )
               
               return resolved
            }
            
            for cloud in viewModel.clouds {
               context.translateBy(x: cloud.position.x, y: cloud.position.y)
               context.scaleBy(x: cloud.scale, y: cloud.scale)
               context.draw(resolvedImages[cloud.imageNumber], at: .zero, anchor: .topLeading)
               context.transform = .identity
            }
         }
      }
      .ignoresSafeArea()
      .frame(maxWidth: .infinity, maxHeight: .infinity)
   }
}

struct CloudsView_Previews: PreviewProvider {
   static let exampleWeather = PreviewManager.exampleWeather
   
   static var time: Double {
      var calendar = Calendar(identifier: .gregorian)
      calendar.timeZone = exampleWeather.timeZone
      let currentTime = exampleWeather.current.dateTime
      let startSeconds = calendar.startOfDay(for: currentTime).timeIntervalSince1970
      let currentSeconds = currentTime.timeIntervalSince1970
      return (currentSeconds - startSeconds) / 86400
   }
   
   static var previews: some View {
      CloudsView(cloudPercent: exampleWeather.current.clouds, time: time, graySky: false)
         .background(Color.stormEveningStart)
         .previewLayout(.sizeThatFits)
   }
}
