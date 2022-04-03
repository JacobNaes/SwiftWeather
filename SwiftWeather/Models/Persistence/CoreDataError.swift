//
//  CoreDataError.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 4/3/22.
//

import Foundation

enum CoreDataError: Error {
   case invalidObject
   case saveError
   case missingValue
}

extension CoreDataError: LocalizedError {
   var errorDescription: String? {
      switch self {
         case .invalidObject:
            return NSLocalizedString("Object is not a stored type", comment: "")
         case .saveError:
            return NSLocalizedString("Failed to save context", comment: "")
         case .missingValue:
            return NSLocalizedString("Missing Core Data Optional", comment: "")
      }
   }
}
