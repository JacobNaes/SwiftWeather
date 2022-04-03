//
//  PreviewManager.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/29/22.
//

import Foundation
import CoreData

class PreviewManager {
   static let exampleWeatherData: WeatherData = loadBundleFile(name: "ExampleWeather.json")
   static let exampleLocationsData: [LocationData] = loadBundleFile(name: "ExampleLocations.json")
   
   static let favoriteWeatherExampleData: [WeatherData] = loadBundleFile(name: "FavoriteWeatherExamples.json")
   static let favoriteLocationsExampleData: [[LocationData]] = loadBundleFile(name: "FavoriteLocationsExample.json")
   
   static var exampleWeather: Weather = {
      makeWeather()
   }()
   
   static private func loadBundleFile<T: Decodable>(name: String) -> T {
      let path = Bundle.main.path(forResource: name, ofType: nil)!
      let jsonDecoder = JSONDecoder()
      jsonDecoder.dateDecodingStrategy = .secondsSince1970
      do {
         let data = try Data(contentsOf: URL(fileURLWithPath: path))
         let results = try jsonDecoder.decode(T.self, from: data)
         return results
      } catch {
         fatalError("error loading decodable from bundle")
      }
   }
   
   static private func loadBundleData(name: String) -> Data {
      let path = Bundle.main.path(forResource: name, ofType: nil)!
      do {
         let data = try Data(contentsOf: URL(fileURLWithPath: path))
         return data
      } catch {
         fatalError("error loading decodable from bundle")
      }
   }
   
   private static func makeWeather() -> Weather {
      let weatherData = exampleWeatherData
      let locationData = exampleLocationsData.first!
      let timeZone = TimeZone(secondsFromGMT: weatherData.timeZoneOffset)!
      let location = makeLocation(data: locationData, timeZone: timeZone)
      let current = makeCurrentWeather(weatherData: weatherData, timeZone: timeZone)
      let daily = weatherData.daily.map { makeDayWeather(data: $0, currentTime: weatherData.current.dateTime, timeZone: timeZone) }
      
      let hourly: [Weather.HourWeather] = weatherData.hourly.map { hourData in
         let hourComponents = Calendar.current.dateComponents(in: timeZone, from: hourData.hour)
         
         let matchingDay = weatherData.daily.first { dayWeatherData in
            let dayComponents = Calendar.current.dateComponents(in: timeZone, from: dayWeatherData.day)
            return hourComponents.day == dayComponents.day && hourComponents.month == dayComponents.month
         }
         
         return makeHourWeather(data: hourData, sunrise: matchingDay!.sunrise, sunset: matchingDay!.sunset, timeZone: timeZone)
      }
      
      return Weather(
         managedObjectID: NSManagedObjectID(),
         location: location,
         current: current,
         daily: daily,
         hourly: hourly,
         timeZone: timeZone
      )
   }
   
   private static func makeLocation(data: LocationData, timeZone: TimeZone) -> Location {
      Location(id: data.id, name: data.name, region: data.region, country: data.country, lat: data.lat, lon: data.lon, timeZone: timeZone)
   }
   
   private static func makeCurrentWeather(weatherData: WeatherData, timeZone: TimeZone) -> Weather.CurrentWeather {
      let currentData = weatherData.current
      let isDay = currentData.dateTime > currentData.sunrise && currentData.dateTime < currentData.sunset
      return Weather.CurrentWeather(
         clouds: currentData.clouds,
         dewPoint: Measurement(value: currentData.dewPoint, unit: .fahrenheit),
         dateTime: currentData.dateTime,
         feelsLike: Measurement(value: currentData.feelsLike, unit: .fahrenheit),
         humidity: currentData.humidity,
         pressure: Measurement(value: currentData.pressure, unit: .hectopascals),
         sunrise: currentData.sunrise,
         sunset: currentData.sunset,
         temp: Measurement(value: currentData.temp, unit: .fahrenheit),
         uvi: currentData.uvi,
         visibility: Measurement(value: currentData.visibility, unit: .meters),
         condition: makeCondition(data: currentData.conditions.first!, time: currentData.dateTime, timeZone: timeZone, isDay: isDay),
         windDeg: Measurement(value: currentData.windDeg, unit: .degrees),
         windGust: Measurement(value: currentData.windGust, unit: .milesPerHour),
         windSpeed: Measurement(value: currentData.windSpeed, unit: .milesPerHour),
         timeZone: timeZone
      )
   }
   
   private static func makeDayWeather(data: WeatherData.Day, currentTime: Date, timeZone: TimeZone) -> Weather.DayWeather {
      let isDay = currentTime > data.sunrise && currentTime < data.sunset
      return Weather.DayWeather(
         clouds: data.clouds,
         dewPoint: Measurement(value: data.dewPoint, unit: .fahrenheit),
         day: data.day,
         humidity: data.humidity,
         moonPhase: data.moonPhase,
         moonrise: data.moonrise,
         moonset: data.moonset,
         precipitationChance: data.precipitationChance,
         pressure: Measurement(value: data.pressure, unit: .hectopascals),
         sunrise: data.sunrise,
         sunset: data.sunset,
         tempMax: Measurement(value: data.maxTemp, unit: .fahrenheit),
         tempMin: Measurement(value: data.minTemp, unit: .fahrenheit),
         uvi: data.uvi,
         condition: makeCondition(data: data.conditions.first!, time: data.day, timeZone: timeZone, isDay: isDay),
         windDeg: Measurement(value: data.windDeg, unit: .degrees),
         windGust: Measurement(value: data.windGust, unit: .milesPerHour),
         windSpeed: Measurement(value: data.windSpeed, unit: .milesPerHour),
         timeZone: timeZone,
         rain: Measurement(value: data.rain, unit: .milliliters),
         snow: Measurement(value: data.snow, unit: .milliliters)
      )
   }
   
   private static func makeHourWeather(data: WeatherData.Hour, sunrise: Date, sunset: Date, timeZone: TimeZone) -> Weather.HourWeather {
      let isDay = data.hour > sunrise && data.hour < sunset
      return Weather.HourWeather(
         clouds: data.clouds,
         dewPoint: Measurement(value: data.dewPoint, unit: .fahrenheit),
         hour: data.hour,
         feelsLike: Measurement(value: data.feelsLike, unit: .fahrenheit),
         humidity: data.humidity,
         pressure: Measurement(value: data.pressure, unit: .hectopascals),
         precipitationChance: data.precipitationChance,
         temp: Measurement(value: data.temp, unit: .fahrenheit),
         uvi: data.uvi,
         visibility: Measurement(value: data.visibility, unit: .meters),
         condition: makeCondition(data: data.conditions.first!, time: data.hour, timeZone: timeZone, isDay: isDay),
         windDeg: Measurement(value: data.windDeg, unit: .degrees),
         windGust: Measurement(value: data.windGust, unit: .milesPerHour),
         windSpeed: Measurement(value: data.windSpeed, unit: .milesPerHour),
         daySunrise: sunrise,
         daySunset: sunset,
         timeZone: timeZone
      )
   }
   
   private static func makeCondition(data: WeatherData.Condition, time: Date, timeZone: TimeZone, isDay: Bool) -> Weather.WeatherCondition {
      return Weather.WeatherCondition(
         code: data.code,
         main: data.main,
         detail: data.detail,
         time: time,
         timeZone: timeZone,
         isDay: isDay
      )
   }
}
