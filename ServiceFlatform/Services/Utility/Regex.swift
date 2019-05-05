//
//  Regex.swift
//  ServicePlatform
//

//

import Foundation

public struct Regex {

  // MARK: - Regex
  public static let mentionRegex: NSRegularExpression? = {
    do {
      return try NSRegularExpression(pattern: "(?<!\\w)@([\\w\\_|-]+)?", options: .caseInsensitive)
    } catch {
      return nil
    }
  }()

  public static let urlRegex: NSRegularExpression? = {
    do {
      return try NSRegularExpression(pattern: "(http(s)?:\\/\\/)?(www\\.)?[-a-zA-Z0-9\\@:%_\\+~#=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9\\@:%_\\+.~#?&//=]*)", options: .caseInsensitive)
    } catch {
      return nil
    }
  }()

  public static let urlDetector: NSDataDetector? = {
    do {
      return try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    } catch let err {
      print(err)
      return nil
    }
  }()

  /// Detect mentioned users by using regex
  ///
  /// - Parameters:
  ///   - names: list of names for checking the exist
  ///   - text: fulltext
  ///   - callback: found element handler
  @discardableResult public static func regexMention(names: Set<String>, text: String, callback: ((NSRange) -> Void)? = nil) -> [NSRange] {
    let textLength = (text as NSString).length
    var matches = [NSRange]()
    Regex.mentionRegex?.enumerateMatches(in: text, options: [], range: NSRange(location: 0, length: textLength), using: { (result, flag, stop) in
      if let range = result?.range {
        let meetRange = NSRange(location: range.location + 1, length: range.length - 1)
        /// Just highlight tagged users
        if textLength > meetRange.location {
          /// Make sure that location is inside text range
          let sub = (text as NSString).substring(with: meetRange)
          let (contained, foundLength) = Utility.contains(list: Set(names), text: sub)
          if contained {
            let foundRange = NSRange(location: range.location, length: foundLength + 1)
            matches.append(foundRange)
            callback?(foundRange)
          }
        }
      }
    })
    return matches
  }

  /// Detect urls by using regex
  ///
  /// - Parameters:
  ///   - text: fulltext
  ///   - callback: found element handler
  @discardableResult public static func regexUrl(text: String, callback: ((NSRange) -> Void)? = nil) -> [NSRange] {
    let textLength = (text as NSString).length
    var matches = [NSRange]()

    Regex.urlDetector?.matches(in: text, options: [], range: NSRange(location: 0, length: textLength)).forEach({ (res) in
      let sub = (text as NSString).substring(with: res.range)
      let subs = sub.components(separatedBy: ".")
      if let prefix = subs.first?.lowercased(), (prefix.contains("www") || prefix[prefix.index(prefix.endIndex, offsetBy: -1)] == "/") && subs.count < 3 {
        print("detector ignore: ", sub)
      } else if validateUrl(url: sub) {
        matches.append(res.range)
        callback?(res.range)
      }
    })
    return matches
  }

  /// Validate url text is a properly formatted URL
  ///
  /// - Parameter url: url text
  /// - Returns: boolean flag
  public static func validateUrl(url: String) -> Bool {
    if let regex = Regex.urlRegex {
      return regex.firstMatch(in: url, options: [], range: NSRange(location: 0, length: (url as NSString).length)).notNil
    }
    return false
  }
}
