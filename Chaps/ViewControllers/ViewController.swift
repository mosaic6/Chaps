//
//  ViewController.swift
//  Chaps
//
//  Created by Joshua Walsh on 4/28/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import UIKit
import CoreLocation
import ForecastIO
import Firebase

class ViewController: UIViewController {

  let forecastAPI = "2d3a728b58d6c21983e13d6aba624a5a"
  let manager = CLLocationManager()
  var location: CLLocation?

  override func viewDidLoad() {
    super.viewDidLoad()

    checkLocationServices()
    getCurrentLocation()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      self.getWeatherForecast()
    }
  }

  func checkLocationServices() {
    if CLLocationManager.locationServicesEnabled() {
      switch(CLLocationManager.authorizationStatus()) {
      case .notDetermined, .restricted, .denied:
        print("no access")
      case .authorizedAlways, .authorizedWhenInUse:
        self.getCurrentLocation()
      @unknown default:
        fatalError()
      }
    }
  }

  // MARK: - Get users location

  @objc
  func getCurrentLocation() {
    self.manager.requestWhenInUseAuthorization()

    if CLLocationManager.locationServicesEnabled() {
      manager.delegate = self
      manager.desiredAccuracy = kCLLocationAccuracyBest
      manager.startUpdatingLocation()
    }
  }

  // MARK: Get Forecast

  func getWeatherForecast() {
    let forecastService = ForecastService(APIKey: forecastAPI)
    guard let latitude = location?.coordinate.latitude, let longitude = location?.coordinate.longitude else { return }
    forecastService.getWeather(latitude, lon: longitude) { weather in
      if let temp = weather?.currently.temperature,
        let nearestStorm = weather?.currently.nearestStormDistance {
        let alert = UIAlertController(title: "\(temp)°",
          message: "Nearest storm: \(nearestStorm) miles", preferredStyle: .alert)

        let actionButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(actionButton)

        self.present(alert, animated: true, completion: nil)
      }
    }
  }

}

// MARK: CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      self.location = location
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to find user's location: \(error.localizedDescription)")
  }
}
