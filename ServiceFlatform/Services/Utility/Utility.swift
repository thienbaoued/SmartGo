//
//  Utility.swift
//  ServicePlatform
//
//

import Foundation

public struct Utility {

  public static func getUniqueDeviceID() -> String {
    return UIDevice.current.identifierForVendor?.uuidString ?? ""
  }

  /// MARK: Save and retrieve values by keys from User storage
  public static func save(datas: [(Any?, String)]) {
    let userDefault = UserDefaults.standard
    datas.forEach { (value, key) in
      userDefault.set(value, forKey: key)
    }
  }

  public static func retrieve(key: String) -> Any? {
    return UserDefaults.standard.value(forKey: key)
  }

  /// Serializing data to json, return nil if cannot serialize
  ///
  /// - Parameter data: inputting data
  /// - Returns: optional json type
  public static func serializeJSON(data: Data?) -> [String: Any]? {
    guard let data = data else { return nil }
    do {
      if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
        return json
      }
    } catch let err {
      print(err)
    }
    return nil
  }

  /// Convert dictionary to Data
  public static func serializeData(json: [String: Any]?) -> Data? {
    guard let json = json else { return nil }
    return try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
  }

  /// Decode json to model in given type
  ///
  /// - Parameter json: target json
  /// - Returns: optional model object
  public static func decode<T: Decodable>(json: Any) -> T? {
    guard JSONSerialization.isValidJSONObject(json) else { return nil }
    guard let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else { return nil }
    return try? JSONDecoder().decode(T.self, from: data)
  }

  /// Encoding an encodable object to JSON
  ///
  /// - Parameter obj: given object
  /// - Returns: optional json
  public static func encode<T: Encodable>(_ obj: T) -> [String: Any] {
    // swiftlint:disable force_try
    return Utility.serializeJSON(data: try! JSONEncoder().encode(obj))!
  }

  /// Format number to text converting in grammar
  ///
  /// - Parameters:
  ///   - number: number
  ///   - single: suffix for single
  ///   - plural: suffix for plural
  /// - Returns: formatted text
  public static func grammarNumber(_ number: Int, _ single: String, _ plural: String) -> String {
    return "\(Utility.formatCounter(number)) " + (number != 1 ? plural : single)
  }

  /// Correct number to get rid of nagative value
  ///
  /// - Parameter val: inputting value
  /// - Returns: corrected value
  public static func absNumber(val: Int) -> Int {
    return val < 0 ? 0: val
  }

  /// Convert counter number to string in specific format:
  /// If counter > 999, convert to K unit
  ///
  /// - Parameter counter: counter number in Int unit
  /// - Returns: formatted string
  public static func formatCounter(_ counter: Int, unit: String = "K") -> String {
    if counter >= 1000 {
      let mod = Int((counter % 1000) / 100)
      let decimal = Int(counter / 1000)
      let suffix = mod == 0 ? "": ".\(mod)"
      return "\(decimal)" + suffix + unit
    }
    return "\(counter)"
  }

  /// The concept of optimizing query objects from a large list is caching index of object in a dictionary with format: [String: [Int]],
  /// key is id of object, value is an array of object index in the list.
  /// Whenever we want to retrive all objects that have the same `key` from the list, we just need to get cached indexes from dictionary by `key` and then getting objects in the list by index
  /// This solution will just take the complexity in linear time (that's O(n))
  ///
  /// - Parameters:
  ///   - dict: index cached dictionary
  ///   - key: query key
  ///   - list: list of objects
  /// - Returns: array of tuple data including index and object
  public static func elementsIn<T>(dict: [String: [Int]], by key: Int, from list: [T]) -> [(Int, T)] {
    if let val = dict["\(key)"] {
      let indices = list.indices
      return val.compactMap({ idx in
        if indices ~= idx {
          return (idx, list[idx])
        }
        return nil
      })
    }
    return []
  }

  /// Detect a list contains an element by its entire content or just a prefix
  ///
  /// - Parameters:
  ///   - list: target list
  ///   - range: current range of inputting text
  ///   - text: need-to-check element
  /// - Returns: tuple of exists flag and length of text
  public static func contains(list: Set<String>, text: String) -> (Bool, Int) {
    var contained = list.contains(text)
    var length = text.count
    if !contained {
      for element in list where text.hasPrefix(element) {
        length = element.count
        contained = true
        break
      }
    }
    return (contained, length)
  }

  /// Removing an element of array that is value of specific key in dictionary
  ///
  /// - Parameters:
  ///   - key: query key
  ///   - value: removed value
  ///   - dict: caching dictionary
  public static func removeValue(_ value: Int, by key: Int, from dict: inout [String: [Int]]) {
    if var values = dict["\(key)"], let idx = values.index(of: value) {
      values.remove(at: idx)
      dict["\(key)"] = values.isEmpty ? nil: values
    }
  }
}
