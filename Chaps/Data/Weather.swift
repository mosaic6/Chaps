//
//  Weather.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/5/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation
import UIKit

struct Weather: Decodable {
  let latitude: Double
  let longitude: Double
  let timezone: String
  let offset: Int
  let currently: Currently
//  let minutely: Minutely?
//  let hourly: Hourly
//  let daily: Daily?
//  let alerts: [Alerts]?
  let flags: Flags?

  struct Currently: Decodable {
    let time: Int
    let summary: String
    let icon: String
    let nearestStormDistance: Int
    let precipIntensity: Double
    let precipIntensityError: Double?
    let precipProbability: Double
    let precipType: String?
    let temperature: Double
    let apparentTemperature: Double
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let visibility: Double
    let ozone: Double
  }

  struct Minutely: Decodable {
    let summary: String
    let icon: String
    let data: [MinuteData]

    struct MinuteData: Codable {
      let time: Int
      let precipIntensity: Double
      let precipIntensityError: Double
      let precipProbability: Double
      let precipType: Double?
    }
  }

  struct Hourly: Decodable {
    let summary: String
    let icon: String
    let data: [HourlyData]

    struct HourlyData: Decodable {
      let time: Int
      let summary: String
      let icon: String
      let precipIntensity: Double
      let precipProbability: Double
      let precipType: String?
      let temperature: Double
      let apparentTemperature: Double
      let dewPoint: Double
      let humidity: Double
      let pressure: Double
      let windSpeed: Double
      let windGust: Double
      let windBearing: Int
      let cloudCover: Double
      let uvIndex: Int
      let visibility: Double
      let ozone: Double
    }
  }

  struct Daily: Decodable {
    let summary: String
    let icon: String
    let data: [DailyData]

    struct DailyData: Decodable {
      let time: Int
      let summary: String
      let icon: String
      let sunriseTime: Int
      let sunsetTime: Int
      let moonPhase: Double
      let precipIntensity: Double
      let precipIntensityMax: Double
      let precipIntensityMaxTime: Int
      let precipProbability: Double
      let precipType: String?
      let temperatureHigh: Double
      let temperatureHighTime: Int
      let temperatureLow: Double
      let temperatureLowTime: Int
      let apparentTemperatureHigh: Double
      let apparentTemperatureHighTime: Int
      let apparentTemperatureLow: Double
      let apparentTemperatureLowTime: Int
      let dewPoint: Double
      let humidity: Double
      let pressure: Double
      let windSpeed: Double
      let windGust: Double
      let windGustTime: Int
      let windBearing: Int
      let cloudCover: Double
      let uvIndex: Int
      let uvIndexTime: Int
      let visibility: Int
      let ozone: Double
      let temperatureMin: Double
      let temperatureMinTime: Int
      let temperatureMax: Double
      let temperatureMaxTime: Int
      let apparentTemperatureMin: Double
      let apparentTemperatureMinTime: Int
      let apparentTemperatureMax: Double
      let apparentTemperatureMaxTime: Int
    }
  }

  struct Alerts: Decodable {
    let title: String
    let time: Int
    let expires: Int
    let description: String
    let uri: String
  }

  struct Flags: Decodable {
    let units: String
  }

}
