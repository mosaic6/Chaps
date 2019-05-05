//
//  ViewController.swift
//  Chaps
//
//  Created by Joshua Walsh on 4/28/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import UIKit
import Weathersama
import SlackKit

class ViewController: UIViewController {

  var weatherAPI: Weathersama!

  override func viewDidLoad() {
    super.viewDidLoad()

//    setupWeather()
    setupSlack()
  }

  func setupWeather() {
    weatherAPI = Weathersama(appId: "3e399a019a3786d9a7ae9e84b6e5893b",
                             temperature: .Fahrenheit,
                             language: .English,
                             dataResponse: DATA_RESPONSE.JSON)
    weatherAPI.delegete = self
    // TODO: update weather model
  }

  func setupLocation() {
    // TODO: core location to pass to weather
  }

}

extension ViewController: WeathersamaDelegete {
  func didStartRequestResponder() {
    print("Start Request")
  }

  func didEndRequestResponder(result: Bool, description: String, requestType: REQUEST_TYPE) {
    if result {
      if requestType == .dailyForecast {

      } else if requestType == .Forecast {

      } else if requestType == .Weather {

      }
    }
  }


}
