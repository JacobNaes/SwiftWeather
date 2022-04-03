//
//  LocationData.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/29/22.
//

import Foundation

struct LocationData: Identifiable {
   let id: Int
   let name: String
   let region: String
   let country: String
   let lat: Double
   let lon: Double
}

extension LocationData: Decodable {
   enum CodingKeys: String, CodingKey {
      case id, name, region, country, lat, lon
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = try container.decode(Int.self, forKey: .id)
      name = try container.decode(String.self, forKey: .name)
      region = try container.decode(String.self, forKey: .region)
      country = try container.decode(String.self, forKey: .country)
      lat = try container.decode(Double.self, forKey: .lat)
      lon = try container.decode(Double.self, forKey: .lon)
   }
}
