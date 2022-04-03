//
//  WeatherMO-Update.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/29/22.
//

import Foundation

extension WeatherMO {
   func update(weatherData: WeatherData, locationData: LocationData, usersLocation: Bool) {
      if daily.count != weatherData.daily.count,
         hourly.count != weatherData.hourly.count {
         // FIXME: Testing purposes only
         fatalError("WeatherData and WeatherMO should have same size day/hour weather arrays")
      }
      
      isUserWeather = usersLocation
      locationID_ = Int32(locationData.id)
      locationName_ = locationData.name
      locationCountry_ = locationData.country
      locationRegion_ = locationData.region
      latitude = locationData.lat
      longitude = locationData.lon
      timeOffset = Int64(weatherData.timeZoneOffset)
      
      current.update(data: weatherData.current, timeZone: timeZone)
      
      for (dayData, dayMO) in zip(weatherData.daily, daily) {
         dayMO.update(data: dayData, timeZone: timeZone)
      }
      
      for (hourData, hourMO) in zip(weatherData.hourly, hourly) {
         hourMO.update(data: hourData, daysData: weatherData.daily, timeZone: timeZone)
      }
   }
}

fileprivate extension CurrentWeatherMO {
   func update(data currentData: WeatherData.Current, timeZone: TimeZone) {
      timeOffset = Int64(timeZone.secondsFromGMT())
      clouds = currentData.clouds
      date_ = currentData.dateTime
      dewPoint = currentData.dewPoint
      feelsLike = currentData.feelsLike
      humidity = currentData.humidity
      pressure = currentData.pressure
      sunrise_ = currentData.sunrise
      sunset_ = currentData.sunset
      temp = currentData.temp
      uvi = currentData.uvi
      visibility = currentData.visibility
      windAngle = currentData.windDeg
      windGust = currentData.windGust
      windSpeed = currentData.windSpeed
      condition_.updateOptional(data: currentData.conditions.primary, time: date, timeZone: timeZone, isDay: isDay)
   }
}

fileprivate extension DayWeatherMO {
   func update(data dayData: WeatherData.Day, timeZone: TimeZone) {
      timeOffset = Int64(timeZone.secondsFromGMT())
      clouds = dayData.clouds
      day_ = dayData.day
      dewPoint = dayData.dewPoint
      feelsLikeTempDay = dayData.feelsLikeTempDay
      humidity = dayData.humidity
      moonPhase = dayData.moonPhase
      moonrise_ = dayData.moonrise
      moonset_ = dayData.moonset
      precipitationChance = dayData.precipitationChance
      pressure = dayData.pressure
      sunrise_ = dayData.sunrise
      sunset_ = dayData.sunset
      tempMax = dayData.maxTemp
      tempMin = dayData.minTemp
      uvi = dayData.uvi
      rain = dayData.rain
      snow = dayData.snow
      windAngle = dayData.windDeg
      windGust = dayData.windGust
      windSpeed = dayData.windSpeed
      condition_.updateOptional(data: dayData.conditions.primary, time: day, timeZone: timeZone, isDay: true)
   }
}

fileprivate extension HourWeatherMO {
   func update(data hourData: WeatherData.Hour, daysData: [WeatherData.Day], timeZone: TimeZone) {
      timeOffset = Int64(timeZone.secondsFromGMT())
      clouds = hourData.clouds
      dewPoint = hourData.dewPoint
      feelsLike = hourData.feelsLike
      hour_ = hourData.hour
      humidity = hourData.humidity
      precipitationChance = hourData.precipitationChance
      pressure = hourData.pressure
      temp = hourData.temp
      uvi = hourData.uvi
      visibility = hourData.visibility
      windAngle = hourData.windDeg
      windGust = hourData.windGust
      windSpeed = hourData.windSpeed
      
      let hourComponents = Calendar.current.dateComponents(in: timeZone, from: hourData.hour)
      
      let matchingDay = daysData.first { dayWeatherData in
         let dayComponents = Calendar.current.dateComponents(in: timeZone, from: dayWeatherData.day)
         return hourComponents.day == dayComponents.day && hourComponents.month == dayComponents.month
      }
      
      if let matchingDay = matchingDay {
         isDayTime = hourData.hour > matchingDay.sunrise && hourData.hour < matchingDay.sunset
         daySunrise_ = matchingDay.sunrise
         daySunset_ = matchingDay.sunset
         condition_.updateOptional(data: hourData.conditions.primary, time: hour, timeZone: timeZone, isDay: isDayTime)
      } else {
         // FIXME: Testing purposes only
         fatalError("Should be a corresponding day for the hour weather")
      }
   }
}

fileprivate extension WeatherConditionMO {
   func update(data conditionData: WeatherData.Condition, time: Date, timeZone: TimeZone, isDay: Bool) {
      self.timeOffset = Int64(timeZone.secondsFromGMT())
      self.code_ = Int16(conditionData.code)
      self.detail_ = conditionData.detail
      self.main_ = conditionData.main
      self.time_ = time
      self.isDay = isDay
   }
}

fileprivate extension Optional where Wrapped == WeatherConditionMO {
   func updateOptional(data conditionData: WeatherData.Condition, time: Date, timeZone: TimeZone, isDay: Bool) {
      if let self = self {
         self.update(data: conditionData, time: time, timeZone: timeZone, isDay: isDay)
      } else {
         // FIXME: Testing purposes only
         fatalError(CoreDataError.missingValue.localizedDescription)
      }
   }
}
