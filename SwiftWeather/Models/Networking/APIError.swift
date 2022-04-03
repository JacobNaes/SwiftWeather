//
//  APIError.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 4/3/22.
//

import Foundation

enum APIError: Error {
   case decode
   case response
}

extension APIError: LocalizedError {
   var errorDescription: String? {
      switch self {
         case .decode:
            return NSLocalizedString("Failed to decode api data", comment: "")
         case .response:
            return NSLocalizedString("Failed to get data from API", comment: "")
      }
   }
}
