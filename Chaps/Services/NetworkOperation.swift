//
//  NetworkOperation.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/5/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation

class NetworkOperation {
  lazy var config: URLSessionConfiguration = URLSessionConfiguration.default
  lazy var session: URLSession = URLSession(configuration: self.config)
  let queryURL: URL

  init(url: URL) {
    self.queryURL = url
  }

  func jsonFromUrl(_ completion: @escaping (NSDictionary?) -> Void) {
    let request = URLRequest(url: queryURL)

    session.dataTask(with: request) { data, response, _ in
      if let httpResponse = response as? HTTPURLResponse {
        switch httpResponse.statusCode {
        case 200:
          let jsonDict = try? JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
          completion(jsonDict)
        default:
          print("Request failed \(httpResponse.statusCode)")
        }
      } else {
        print("Error: Not a valid HTTP response")
      }
    }.resume()
  }
}
