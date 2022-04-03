//
//  WeatherDetailCell.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/31/22.
//

import SwiftUI

struct WeatherDetailCell<Content: View, Detail: View>: View {
   private let cellFrame: CGFloat = (UIScreen.main.bounds.width * 0.5) - 10
   
   private let label: Label<Text, Image>
   private let mainContent: Content
   private let detail: Detail?
   
   init(label: Label<Text, Image>, @ViewBuilder content: () -> Content, @ViewBuilder detail: () -> Detail) {
      self.label = label
      self.mainContent = content()
      self.detail = detail()
   }
   
   init(label: Label<Text, Image>, @ViewBuilder content: () -> Content, detail: () -> Detail? = { nil }) {
      self.label = label
      self.mainContent = content()
      self.detail = nil
   }
   
   var body: some View {
      VStack(alignment: .leading, spacing: 10) {
         label
            .font(.system(.callout, design: .rounded))
            .foregroundStyle(.secondary)
         
         mainContent
         
         Spacer()
         if let detail = detail {
            detail
               .font(.system(.body, design: .rounded))
         }
      }
      .font(.system(.title2, design: .rounded))
      .padding()
      .frame(maxWidth: .infinity, alignment: .leading)
      .frame(height: cellFrame)
      .background(
         RoundedRectangle(cornerRadius: 12, style: .continuous)
            .foregroundStyle(.thickMaterial)
      )
   }
}

extension WeatherDetailCell where Detail == EmptyView {
   init(label: Label<Text, Image>, @ViewBuilder content: () -> Content) {
      self.init(label: label, content: content, detail: { nil })
   }
}

struct WeatherDetailCell_Previews: PreviewProvider {
   static var previews: some View {
      WeatherDetailCell(label: Label("Temperature", systemImage: "thermometer")) {
         Text("Main")
      }.previewLayout(.sizeThatFits)
      
      WeatherDetailCell(label: Label("Temperature", systemImage: "thermometer")) {
         Text("Main")
      } detail: {
         Text("Detail")
      }.previewLayout(.sizeThatFits)
   }
}
