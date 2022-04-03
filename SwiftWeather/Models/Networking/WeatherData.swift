//
//  WeatherData.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/29/22.
//

import Foundation

struct WeatherData: Decodable {
   let current: Current
   let daily: [Day]
   let hourly: [Hour]
   let lat: Double
   let lon: Double
   let timeZone: String
   let timeZoneOffset: Int
   
   enum CodingKeys: String, CodingKey {
      case current, daily, hourly
      case lat, lon
      case timeZone = "timezone"
      case timeZoneOffset = "timezone_offset"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      current = try container.decode(Current.self, forKey: .current)
      daily = try container.decode([Day].self, forKey: .daily)
      hourly = try container.decode([Hour].self, forKey: .hourly)
      lat = try container.decode(Double.self, forKey: .lat)
      lon = try container.decode(Double.self, forKey: .lon)
      timeZone = try container.decode(String.self, forKey: .timeZone)
      timeZoneOffset = try container.decode(Int.self, forKey: .timeZoneOffset)
   }
}


// MARK: - Current

extension WeatherData {
   struct Current: Decodable {
      let clouds: Double
      let dewPoint: Double
      let dateTime: Date
      let feelsLike: Double
      let humidity: Double
      let pressure: Double
      let sunrise: Date
      let sunset: Date
      let temp: Double
      let uvi: Double
      let visibility: Double
      let conditions: [Condition]
      let windDeg: Double
      let windGust: Double
      let windSpeed: Double
      
      enum CodingKeys: String, CodingKey {
         case clouds
         case dewPoint = "dew_point"
         case dateTime = "dt"
         case feelsLike = "feels_like"
         case humidity, pressure, sunrise, sunset, temp, uvi, visibility
         case conditions = "weather"
         case windDeg = "wind_deg"
         case windGust = "wind_gust"
         case windSpeed = "wind_speed"
      }
      
      init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         clouds = try container.decode(Double.self, forKey: .clouds) / 100.0
         dewPoint = try container.decode(Double.self, forKey: .dewPoint)
         dateTime = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .dateTime))
         feelsLike = try container.decode(Double.self, forKey: .feelsLike)
         humidity = try container.decode(Double.self, forKey: .humidity) / 100.0
         pressure = try container.decode(Double.self, forKey: .pressure)
         sunrise = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .sunrise))
         sunset = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .sunset))
         temp = try container.decode(Double.self, forKey: .temp)
         uvi = try container.decode(Double.self, forKey: .uvi)
         visibility = try container.decode(Double.self, forKey: .visibility)
         conditions = try container.decode([Condition].self, forKey: .conditions)
         windDeg = try container.decode(Double.self, forKey: .windDeg)
         windGust = try container.decodeIfPresent(Double.self, forKey: .windGust) ?? 0
         windSpeed = try container.decode(Double.self, forKey: .windSpeed)
      }
   }
}


// MARK: - Day

extension WeatherData {
   struct Day: Decodable {
      let clouds: Double
      let dewPoint: Double
      let day: Date
      let humidity: Double
      let moonPhase: Double
      let moonrise: Date
      let moonset: Date
      let precipitationChance: Double
      let pressure: Double
      let sunrise: Date
      let sunset: Date
      let maxTemp: Double
      let minTemp: Double
      let feelsLikeTempDay: Double
      let uvi: Double
      let conditions: [Condition]
      let windDeg: Double
      let windGust: Double
      let windSpeed: Double
      let rain: Double
      let snow: Double
      
      enum CodingKeys: String, CodingKey {
         case clouds
         case dewPoint = "dew_point"
         case day = "dt"
         case feelsLike = "feels_like"
         case humidity
         case moonPhase = "moon_phase"
         case moonrise, moonset
         case precipitationChance = "pop"
         case pressure, sunrise, sunset, temp, uvi
         case conditions = "weather"
         case windDeg = "wind_deg"
         case windGust = "wind_gust"
         case windSpeed = "wind_speed"
         case rain, snow
      }
      
      enum TemperatureKeys: String, CodingKey {
         case day, eve, max, min, morn, night
      }
      
      enum FeelsLikeTempKeys: String, CodingKey {
         case day, eve, morn, night
      }
      
      init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         let temperatureContainer = try container.nestedContainer(keyedBy: TemperatureKeys.self, forKey: .temp)
         let feelsLikeTempContainer = try container.nestedContainer(keyedBy: FeelsLikeTempKeys.self, forKey: .feelsLike)
         clouds = try container.decode(Double.self, forKey: .clouds) / 100.0
         dewPoint = try container.decode(Double.self, forKey: .dewPoint)
         day = Date(timeIntervalSince1970: TimeInterval(try container.decode(Int.self, forKey: .day)))
         humidity = try container.decode(Double.self, forKey: .humidity) / 100.0
         moonPhase = try container.decode(Double.self, forKey: .moonPhase)
         moonrise = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .moonrise))
         moonset = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .moonset))
         precipitationChance = try container.decode(Double.self, forKey: .precipitationChance)
         pressure = try container.decode(Double.self, forKey: .pressure)
         sunrise = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .sunrise))
         sunset = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .sunset))
         uvi = try container.decode(Double.self, forKey: .uvi)
         conditions = try container.decode([Condition].self, forKey: .conditions)
         windDeg = try container.decode(Double.self, forKey: .windDeg)
         windGust = try container.decodeIfPresent(Double.self, forKey: .windGust) ?? 0
         windSpeed = try container.decode(Double.self, forKey: .windSpeed)
         maxTemp = try temperatureContainer.decode(Double.self, forKey: .max)
         minTemp = try temperatureContainer.decode(Double.self, forKey: .min)
         feelsLikeTempDay = try feelsLikeTempContainer.decode(Double.self, forKey: .day)
         rain = try container.decodeIfPresent(Double.self, forKey: .rain) ?? 0
         snow = try container.decodeIfPresent(Double.self, forKey: .snow) ?? 0
      }
   }
}


// MARK: - Hour

extension WeatherData {
   struct Hour: Decodable {
      let clouds: Double
      let dewPoint: Double
      let hour: Date
      let feelsLike: Double
      let humidity: Double
      let pressure: Double
      let precipitationChance: Double
      let temp: Double
      let uvi: Double
      let visibility: Double
      let conditions: [Condition]
      let windDeg: Double
      let windGust: Double
      let windSpeed: Double
      
      enum CodingKeys: String, CodingKey {
         case clouds
         case dewPoint = "dew_point"
         case hour = "dt"
         case feelsLike = "feels_like"
         case humidity, pressure
         case precipitationChance = "pop"
         case temp, uvi, visibility
         case conditions = "weather"
         case windDeg = "wind_deg"
         case windGust = "wind_gust"
         case windSpeed = "wind_speed"
      }
      
      init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         clouds = try container.decode(Double.self, forKey: .clouds) / 100.0
         dewPoint = try container.decode(Double.self, forKey: .dewPoint)
         hour = Date(timeIntervalSince1970: TimeInterval(try container.decode(Int.self, forKey: .hour)))
         feelsLike = try container.decode(Double.self, forKey: .feelsLike)
         humidity = try container.decode(Double.self, forKey: .humidity) / 100.0
         pressure = try container.decode(Double.self, forKey: .pressure)
         precipitationChance = try container.decode(Double.self, forKey: .precipitationChance)
         temp = try container.decode(Double.self, forKey: .temp)
         uvi = try container.decode(Double.self, forKey: .uvi)
         visibility = try container.decode(Double.self, forKey: .visibility)
         conditions = try container.decode([Condition].self, forKey: .conditions)
         windDeg = try container.decode(Double.self, forKey: .windDeg)
         windGust = try container.decode(Double.self, forKey: .windGust)
         windSpeed = try container.decode(Double.self, forKey: .windSpeed)
      }
   }
}



// MARK: - Condition

extension WeatherData {
   struct Condition: Decodable {
      let code: Int
      let main: String
      let detail: String
      
      static let `default` = Condition(code: 0, main: "", detail: "")
      
      enum CodingKeys: String, CodingKey {
         case code = "id"
         case main
         case detail = "description"
      }
      
      init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         code = try container.decode(Int.self, forKey: .code)
         main = try container.decode(String.self, forKey: .main)
         detail = try container.decode(String.self, forKey: .detail)
      }
      
      private init(code: Int, main: String, detail: String) {
         self.code = code
         self.main = main
         self.detail = detail
      }
   }
}
