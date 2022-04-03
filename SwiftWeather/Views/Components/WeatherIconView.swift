//
//  WeatherIconView.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/31/22.
//

import SwiftUI

struct WeatherIconView<Content: View>: View {
   private let condition: ConditionType
   private let icon: Image
   private let content: (Image) -> Content
   
   init(icon: Image, condition: ConditionType, content: @escaping (Image) -> Content) {
      self.icon = icon
      self.condition = condition
      self.content = content
   }
   
   var body: some View {
      content(icon)
         .symbolRenderingMode(.palette)
         .weatherIconStyle(condition: condition)
   }
}

struct WeatherIconView_Previews: PreviewProvider {
   static let conditionType = ConditionType.clear
   static var icon: Image {
      Image(systemName: conditionType.getIconName(isDayTime: true))
   }
   
   static var previews: some View {
      WeatherIconView(icon: icon, condition: conditionType) { image in
         image.resizable().scaledToFit()
      }
      .previewLayout(.sizeThatFits)
   }
}
