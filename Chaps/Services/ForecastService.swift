//
//  ForecastService.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/5/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation

struct ForecastService {
  let forecastAPIKey: String
  let forecastBaseURL: URL?

  init(APIKey: String) {
    forecastAPIKey = APIKey
    forecastBaseURL = URL(string: "https://api.darksky.net/forecast/\(forecastAPIKey)/")
  }

  func getWeather(_ lat: Double, lon: Double, completion: @escaping (Weather?) -> Void) {
    if let forecastURL = URL(string: "\(lat),\(lon)", relativeTo: forecastBaseURL) {
      let networkOperation = NetworkOperation(url: forecastURL)

      networkOperation.jsonFromUrl { result in
        let weather = try! Weather(from: result as! Decoder)
        completion(weather)
      }
    }

  }
}
