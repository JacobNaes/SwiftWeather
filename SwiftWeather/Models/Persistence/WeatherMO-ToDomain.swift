//
//  WeatherMO-ToDomain.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/30/22.
//

import Foundation

fileprivate typealias CurrentWeather = Weather.CurrentWeather
fileprivate typealias DayWeather = Weather.DayWeather
fileprivate typealias HourWeather = Weather.HourWeather
fileprivate typealias WeatherCondition = Weather.WeatherCondition

extension WeatherMO {
   func toDomainModel() -> Weather {
      Weather(managedObjectID: objectID,
              location: locationDomainModel(),
              current: current.toDomainModel(),
              daily: daily.toDomainModel(),
              hourly: hourly.toDomainModel(),
              timeZone: timeZone)
   }
}

fileprivate extension WeatherMO {
   func locationDomainModel() -> Location {
      Location(id: locationID,
               name: locationName,
               region: locationRegion,
               country: locationCountry,
               lat: latitude,
               lon: longitude,
               timeZone: timeZone)
   }
}

fileprivate extension CurrentWeatherMO {
   func toDomainModel() -> CurrentWeather {
      CurrentWeather(clouds: clouds,
                     dewPoint: Measurement(value: dewPoint, unit: .fahrenheit),
                     dateTime: date,
                     feelsLike: Measurement(value: feelsLike, unit: .fahrenheit),
                     humidity: humidity,
                     pressure: Measurement(value: pressure, unit: .hectopascals),
                     sunrise: sunrise,
                     sunset: sunset,
                     temp: Measurement(value: temp, unit: .fahrenheit),
                     uvi: uvi,
                     visibility: Measurement(value: visibility, unit: .meters),
                     condition: condition_.toDomainModel(),
                     windDeg: Measurement(value: windAngle, unit: .degrees),
                     windGust: Measurement(value: windGust, unit: .milesPerHour),
                     windSpeed: Measurement(value: windSpeed, unit: .milesPerHour),
                     timeZone: timeZone)
   }
}

fileprivate extension DayWeatherMO {
   func toDomainModel() -> DayWeather {
      DayWeather(clouds: clouds,
                 dewPoint: Measurement(value: dewPoint, unit: .fahrenheit),
                 day: day,
                 humidity: humidity,
                 moonPhase: moonPhase,
                 moonrise: moonrise,
                 moonset: moonset,
                 precipitationChance: precipitationChance,
                 pressure: Measurement(value: pressure, unit: .hectopascals),
                 sunrise: sunrise,
                 sunset: sunset,
                 tempMax: Measurement(value: tempMax, unit: .fahrenheit),
                 tempMin: Measurement(value: tempMin, unit: .fahrenheit),
                 uvi: uvi,
                 condition: condition_.toDomainModel(),
                 windDeg: Measurement(value: windAngle, unit: .degrees),
                 windGust: Measurement(value: windGust, unit: .milesPerHour),
                 windSpeed: Measurement(value: windSpeed, unit: .milesPerHour),
                 timeZone: timeZone,
                 rain: Measurement(value: rain, unit: .milliliters),
                 snow: Measurement(value: snow, unit: .milliliters))
   }
}

fileprivate extension HourWeatherMO {
   func toDomainModel() -> HourWeather {
      HourWeather(clouds: clouds,
                  dewPoint: Measurement(value: dewPoint, unit: .fahrenheit),
                  hour: hour,
                  feelsLike: Measurement(value: feelsLike, unit: .fahrenheit),
                  humidity: humidity,
                  pressure: Measurement(value: pressure, unit: .hectopascals),
                  precipitationChance: precipitationChance,
                  temp: Measurement(value: temp, unit: .fahrenheit),
                  uvi: uvi,
                  visibility: Measurement(value: visibility, unit: .meters),
                  condition: condition_.toDomainModel(),
                  windDeg: Measurement(value: windAngle, unit: .degrees),
                  windGust: Measurement(value: windGust, unit: .milesPerHour),
                  windSpeed: Measurement(value: windSpeed, unit: .milesPerHour),
                  daySunrise: daySunrise,
                  daySunset: daySunset,
                  timeZone: timeZone)
   }
}


fileprivate extension WeatherConditionMO {
   func toDomainModel() -> WeatherCondition {
      WeatherCondition(code: code,
                       main: main,
                       detail: detail,
                       time: time,
                       timeZone: timeZone,
                       isDay: isDay)
   }
}

fileprivate extension Optional where Wrapped == WeatherConditionMO {
   func toDomainModel() -> WeatherCondition {
      WeatherCondition(code: self?.code ?? 0,
                       main: self?.main ?? "",
                       detail: self?.detail ?? "",
                       time: self?.time ?? .now,
                       timeZone: .autoupdatingCurrent,
                       isDay: self?.isDay ?? true)
   }
}

fileprivate extension Array where Element == DayWeatherMO {
   func toDomainModel() -> [DayWeather] {
      self.map { $0.toDomainModel() }
   }
}

fileprivate extension Array where Element == HourWeatherMO {
   func toDomainModel() -> [HourWeather] {
      self.map { $0.toDomainModel() }
   }
}
