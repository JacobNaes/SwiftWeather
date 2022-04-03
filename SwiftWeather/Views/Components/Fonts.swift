//
//  Fonts.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 4/2/22.
//

import SwiftUI

extension UIFont {
   static let largeNavigationBarFont = customFont(size: 35, weight: .semibold, design: .rounded)
   static let standardNavigationBarFont = customFont(size: 25, weight: .regular, design: .rounded)
   
   private static func customFont(size: CGFloat, weight: UIFont.Weight, design: UIFontDescriptor.SystemDesign) -> UIFont {
      let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
      let font: UIFont
      if let descriptor = systemFont.fontDescriptor.withDesign(design) {
         font = UIFont(descriptor: descriptor, size: size)
      } else {
         font = systemFont
      }
      return font
   }
}
