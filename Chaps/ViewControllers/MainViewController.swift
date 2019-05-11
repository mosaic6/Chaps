//
//  MainViewController.swift
//  Chaps
//
//  Created by Joshua Walsh on 4/28/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import UIKit
import CoreLocation
import ForecastIO
import Firebase

class MainViewController: UIViewController {

  // MARK: Variables

  let forecastAPI = "2d3a728b58d6c21983e13d6aba624a5a"
  let manager = CLLocationManager()
  var location: CLLocation?

  var groups: [Group] = []

  // MARK: Outlets

  @IBOutlet weak var collectionView: UICollectionView!

  // MARK: 
  override func viewDidLoad() {
    super.viewDidLoad()

  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    checkUserAuth { isSignedIn in
      if isSignedIn {
        self.checkLocationServices()
        self.getCurrentLocation()
      }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      self.getWeatherForecast()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    configureCollectionView()
  }

  // MARK: Configure CollectionView

  func configureCollectionView() {
    self.collectionView.delegate = self
    self.collectionView.dataSource = self

    self.collectionView.registerNib(.GroupCardCollectionViewCell)
  }

  // MARK: - Get users location

  func checkLocationServices() {
    if CLLocationManager.locationServicesEnabled() {
      switch CLLocationManager.authorizationStatus() {
      case .notDetermined, .restricted, .denied:
        print("no access")
      case .authorizedAlways, .authorizedWhenInUse:
        self.getCurrentLocation()
      @unknown default:
        fatalError()
      }
    }
  }

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
      print(weather)
//      if let temp = weather?.currently.temperature,
//        let nearestStorm = weather?.currently.nearestStormDistance {
//        let alert = UIAlertController(title: "\(temp)°",
//          message: "Nearest storm: \(nearestStorm) miles", preferredStyle: .alert)
//
//        let actionButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alert.addAction(actionButton)
//
//        self.present(alert, animated: true, completion: nil)
//      }
    }
  }

  // MARK: Get User Status

  func checkUserAuth(_ completion: @escaping (Bool) -> Void) {
//    signOut()
    guard Auth.auth().currentUser != nil else {
      self.performSegue(withIdentifier: "notLoggedIn", sender: nil)
      completion(false)
      return
    }
    completion(true)
  }

  func signOut() {
    do {
      try? Auth.auth().signOut()
    } catch {
      print(error.localizedDescription)
    }
  }

}

// MARK: CollectionViewDelegate

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1 // groups.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withCollectionViewCellNib: .GroupCardCollectionViewCell,
                                                        indexPath: indexPath) as? GroupCardCollectionViewCell else {
                                                          return UICollectionViewCell()
    }

    return cell
  }
  
}

// MARK: CLLocationManagerDelegate

extension MainViewController: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      self.location = location
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to find user's location: \(error.localizedDescription)")
  }
}

// MARK: CellIdentifier
extension MainViewController {

  enum CellIdentifier {
    case groupCard

    var tableViewCellNib: CollectionViewCellNib {
      switch self {
      case .groupCard:
        return .GroupCardCollectionViewCell
      }
    }

    var reuseIdentifier: String {
      switch self {
      case .groupCard:
        return "GroupCardCollectionViewCell"
      }
    }
  }
}
