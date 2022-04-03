//
//  Location.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/29/22.
//

import Foundation

struct Location: Identifiable {
   let id: Int
   let name: String
   let region: String
   let country: String
   let lat: Double
   let lon: Double
   let timeZone: TimeZone
}
