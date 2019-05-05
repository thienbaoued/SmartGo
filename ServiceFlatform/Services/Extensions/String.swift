//
//  File.swift
//  ServicePlatform
//
//

import Foundation

public extension String {
  
  /// MARK: Subscripts
  public subscript(value: PartialRangeUpTo<Int>) -> Substring {
    get {
      return self[..<index(startIndex, offsetBy: value.upperBound)]
    }
  }

  public subscript(value: PartialRangeThrough<Int>) -> Substring {
    get {
      return self[...index(startIndex, offsetBy: value.upperBound)]
    }
  }

  public subscript(value: PartialRangeFrom<Int>) -> Substring {
    get {
      return self[index(startIndex, offsetBy: value.lowerBound)...]
    }
  }

  public func substring(to: Int) -> String {
    return String(self[...min(count - 1, to)])
  }

  public func substring(from: Int) -> String {
    return String(self[max(0, from)...])
  }
  
  subscript (i: Int) -> String {
    return self[i ..< i + 1]
  }
  
  subscript (r: Range<Int>) -> String {
    let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                        upper: min(count, max(0, r.upperBound))))
    let start = index(startIndex, offsetBy: range.lowerBound)
    let end = index(start, offsetBy: range.upperBound - range.lowerBound)
    return String(self[start ..< end])
  }

  /// MARK: Extended functions
  public func trim() -> String {
    return self.trimmingCharacters(in: .whitespacesAndNewlines)
  }


  /// Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
  public func truncate(length: Int, trailing: String = "") -> String {
    return (self.count > length) ? (String(self.prefix(length)) + trailing) : self
  }

  /// Determine whether the given value in string type is Zero or not
  public var isZero: Bool {
    if let num = self.components(separatedBy: " ").first, let inFloat = Float(num), inFloat == 0.0 {
      return true
    }
    return false
  }

  public func encodeURL() -> URL? {
    if let encodedURL = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
      return URL(string: encodedURL)
    }
    return nil
  }

  public func nsRange(from range: Range<Index>) -> NSRange {
    if let lower = UTF16View.Index(range.lowerBound, within: utf16),
      let upper = UTF16View.Index(range.upperBound, within: utf16) {
      return NSRange(location: utf16.distance(from: utf16.startIndex, to: lower), length: utf16.distance(from: lower, to: upper))
    }
    return NSRange()
  }
  
  public var masked: String {
    return String(repeating: "x", count: max(0, count-4)) + String(suffix(4))
  }
  
  public func localized(comment: String = "") -> String {
    return NSLocalizedString(self, comment: comment)
  }
}
