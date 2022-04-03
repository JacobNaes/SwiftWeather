//
//  APIManager.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/29/22.
//

import Foundation

class APIManager {
   static let shared = APIManager()
   
   enum APIEndPoint {
      case weatherForecast(lat: Double, lon: Double)
      case locationSearch(query: String)
   }
   
   private let urlSession = URLSession.shared
   
   func fetchLocation(query: String) async throws -> [LocationData] {
      let locationUrl = APIEndPoint.locationSearch(query: query).url
      
      guard let (data, _) = try? await urlSession.data(from: locationUrl) else {
         throw APIError.response
      }
      
      do {
         return try JSONDecoder().decode([LocationData].self, from: data)
      } catch {
         throw APIError.decode
      }
   }
   
   func fetchWeather(lat: Double, lon: Double) async throws -> WeatherData {
      let weatherUrl = APIEndPoint.weatherForecast(lat: lat, lon: lon).url
      
      guard let (data, _) = try? await urlSession.data(from: weatherUrl) else {
         throw APIError.response
      }
      
      do {
         return try JSONDecoder().decode(WeatherData.self, from: data)
      } catch {
         throw APIError.decode
      }
   }
   
   func fetchBoth(lat: Double, lon: Double) async throws -> (weather: WeatherData, location: [LocationData]) {
      let locationUrl = APIEndPoint.locationSearch(query: "\(lat),\(lon)").url
      let weatherUrl = APIEndPoint.weatherForecast(lat: lat, lon: lon).url
      
      async let (lData, _) = urlSession.data(from: locationUrl)
      async let (wData, _) = urlSession.data(from: weatherUrl)
      
      do {
         let locationData = try await lData
         let weatherData = try await wData
         
         do {
            let location = try JSONDecoder().decode([LocationData].self, from: locationData)
            let weather = try JSONDecoder().decode(WeatherData.self, from: weatherData)
            return (weather, location)
         } catch {
            throw APIError.decode
         }
      } catch {
         throw APIError.response
      }
   }
}

extension APIManager.APIEndPoint {
   private static let weatherAPIKey = APIKeys.weatherAPIKey
   private static let locationAPIKey = APIKeys.locationAPIKey
   
   var url: URL {
      var urlComponents = URLComponents(string: baseUrl)
      urlComponents?.path = path
      urlComponents?.queryItems = queryItems
      
      guard let url = urlComponents?.url else {
         fatalError("Invalid URL")
      }
      
      return url
   }
   
   var baseUrl: String {
      switch self {
         case .weatherForecast:
            return "https://api.openweathermap.org"
         case .locationSearch:
            return "https://api.weatherapi.com"
      }
   }
   
   var path: String {
      switch self {
         case .weatherForecast:
            return "/data/2.5/onecall"
         case .locationSearch:
            return "/v1/search.json"
      }
   }
   
   var queryItems: [URLQueryItem]? {
      switch self {
         case .weatherForecast(let lat, let lon):
            return [
               URLQueryItem(name: "lat", value: "\(lat)"),
               URLQueryItem(name: "lon", value: "\(lon)"),
               URLQueryItem(name: "exclude", value: "minutely"),
               URLQueryItem(name: "units", value: "imperial"),
               URLQueryItem(name: "appid", value: Self.weatherAPIKey),
            ]
         case .locationSearch(let query):
            return [
               URLQueryItem(name: "q", value: query),
               URLQueryItem(name: "key", value: Self.locationAPIKey)
            ]
      }
   }
}
