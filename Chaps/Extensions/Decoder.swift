//
//  Decoder.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/8/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation

// Inspired by https://gist.github.com/mbuchetics/c9bc6c22033014aa0c550d3b4324411a

final class DataDecoder: Decoder {
  var codingPath: [CodingKey] = []
  var userInfo: [CodingUserInfoKey: Any] = [:]

  let data: NSDictionary

  init(_ data: NSDictionary) {
    self.data = data
  }

  func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
    return KeyedDecodingContainer(KDC(data))
  }

  struct KDC<Key: CodingKey>: KeyedDecodingContainerProtocol {
    var codingPath: [CodingKey] = []

    var allKeys: [Key] = []

    let data: NSDictionary

    init(_ data: NSDictionary) {
      self.data = data
    }

    func contains(_ key: Key) -> Bool {
      return data[key.stringValue] != nil
    }

    func decodeNil(forKey key: Key) throws -> Bool {
      return data[key.stringValue] == nil
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
      guard let value = data[key.stringValue] else {
        throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath,
                                                                   debugDescription: "No Bool found"))
      }

      guard let boolValue = value as? Bool else {
        throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath,
                                                                     debugDescription: "No Bool found"))
      }

      return boolValue
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
      guard let value = data[key.stringValue] else {
        throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath,
                                                                   debugDescription: "No String found"))
      }

      guard let strValue = value as? String else {
        throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath,
                                                                     debugDescription: "No String found"))
      }

      return strValue
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
      guard let value = data[key.stringValue] else {
        throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath,
                                                                   debugDescription: "No Double found"))
      }

      guard let doubleValue = value as? Double else {
        throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath,
                                                                     debugDescription: "No Double found"))
      }

      return doubleValue
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
      fatalError()
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
      guard let value = data[key.stringValue] else {
        throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath,
                                                                   debugDescription: "No Int found"))
      }

      guard let intValue = value as? Int else {
        throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath,
                                                                     debugDescription: "No Int found"))
      }

      return intValue
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
      fatalError()
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
      fatalError()
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
      fatalError()
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
      fatalError()
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
      fatalError()
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
      fatalError()
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
      fatalError()
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
      fatalError()
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
      fatalError()
    }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
      guard let value = data[key.stringValue] else {
        throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath,
                                                                   debugDescription: "No Dictionary found"))
      }

      guard let dictValue = value as? NSDictionary else {
        throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath,
                                                                     debugDescription: "No Dictionary found"))
      }

      return try T(from: DataDecoder(dictValue))
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
      fatalError()
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
      fatalError()
    }

    func superDecoder() throws -> Decoder {
      fatalError()
    }

    func superDecoder(forKey key: Key) throws -> Decoder {
      fatalError()
    }
  }

  func unkeyedContainer() throws -> UnkeyedDecodingContainer {
    fatalError()
  }

  func singleValueContainer() throws -> SingleValueDecodingContainer {
    fatalError()
  }
}
