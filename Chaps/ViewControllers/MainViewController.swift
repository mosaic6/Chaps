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

  private var groups: [Group]? {
    didSet {
      loadTableViewData()
    }
  }
	private let currentUser: User? = nil

	private lazy var db = Firestore.firestore()

	private var groupReference: CollectionReference {
		return db.collection("groups")
	}

	private var groupListener: ListenerRegistration?
  private var tableViewData: [[CellIdentifier]] = []
  private var isFlipped: Bool = false

  // MARK: Outlets

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var createButton: RoundButton!
  @IBOutlet weak var eventButton: RoundButton!
  @IBOutlet weak var groupButton: RoundButton!

  // MARK: Actions
  @IBAction func showCreateActions(_ sender: Any) {
    isFlipped = !isFlipped

    UIView.animate(withDuration: 0.3,
                   delay: 0,
                   options: [.allowUserInteraction, .curveEaseInOut],
                   animations: {
                    self.createButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)

                    if self.isFlipped {
                      self.eventButton.frame.origin.y -= 70
                      self.eventButton.frame.origin.x -= 40

                      self.groupButton.frame.origin.y -= 70
                      self.groupButton.frame.origin.x += 40
                    } else {
                      self.eventButton.frame.origin.y += 70
                      self.eventButton.frame.origin.x += 40

                      self.groupButton.frame.origin.y += 70
                      self.groupButton.frame.origin.x -= 40
                    }
    })
  }

  // MARK: Lifecycle

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

    fetchGroups()
    configureTableView()
  }

  // MARK: Fetch Data

  private func loadTableViewData() {
		var tableViewData: [[CellIdentifier]] = []
		var sectionData: [CellIdentifier] = []

		if let groups = self.groups {
			if !groups.isEmpty {
				groups.forEach { group in
					sectionData.append(.groupCard(group))
				}
			}
		}

		tableViewData.append(sectionData)
		self.tableViewData = tableViewData

    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }

  // MARK: Configure CollectionView

  func configureTableView() {
    self.tableView.delegate = self
    self.tableView.dataSource = self

		self.tableView.registerNib(.GroupCardTableViewCell)
    self.tableView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
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
    forecastService.getWeather(latitude, lon: longitude) { _ in
			// TODO: Do something with the weather
    }
  }

  // MARK: Get User Status

  func checkUserAuth(_ completion: @escaping (Bool) -> Void) {
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
    }
  }
}

// MARK: Firestore Requests

private extension MainViewController {

  func fetchGroups() {
    GroupService.shared.fetchGroups { groups in
      guard let groups = groups else { return }

      self.groups = groups
    }
  }
}

// MARK: UITableViewDelegate

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return tableViewData.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tableViewData[section].count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let identifier = self.identifierForIndexPath(indexPath) else { return UITableViewCell() }

		let cell = tableView.dequeueReusableCell(withIdentifier: identifier.reuseIdentifier,
																				 for: indexPath) as! GroupCardTableViewCell
		configureGroupCardDetailCell(cell: cell, indexPath: indexPath)
		return cell
  }

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let currentUser = Auth.auth().currentUser else { return }
		guard let groups = self.groups else { return }
		guard let group = groups[safe: indexPath.row] else { return }
		guard let vc = ChatViewController(user: currentUser, group: group) else { return }
		navigationController?.pushViewController(vc, animated: true)
	}

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let identifier = self.identifierForIndexPath(indexPath) else { return 0.0 }

		switch identifier {
		case .groupCard:
			return 100
		}
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let identifier = self.identifierForIndexPath(indexPath) else { return 0.0 }

		switch identifier {
		case .groupCard:
			return 100
		}
  }

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Groups"
	}

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView()
  }

  fileprivate func identifierForIndexPath(_ indexPath: IndexPath) -> CellIdentifier? {
		return self.tableViewData[safe: indexPath.section]?[safe: indexPath.row]
  }
}

// MARK: Cell Data
extension MainViewController {

  func configureGroupCardDetailCell(cell: UITableViewCell, indexPath: IndexPath) {
    guard let group = self.groups?[safe: indexPath.row] else { return }
		if let cell = cell as? GroupCardTableViewCell {
			cell.configureCell(group: group)
		}
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
		case groupCard(Group)

		var tableViewCellNib: TableViewCellNib {
			switch self {
			case .groupCard:
				return .GroupCardTableViewCell
			}
		}

		var reuseIdentifier: String {
			switch self {
			case .groupCard:
				return "GroupCardTableViewCell"
			}
		}
	}
}
