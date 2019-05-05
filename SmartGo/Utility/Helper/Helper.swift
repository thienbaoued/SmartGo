//
//  Helper.swift
//  Scooter
//
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import Foundation
import UIKit

struct Helper {
  
  /// Getting viewcontroller instance from storyboard
  ///
  /// - Parameters:
  ///   - named: ViewController Identifier string
  ///   - sbNamed: Storyboard name string
  /// - Returns: An optional ViewController instance
  static func getViewController<T: UIViewController>(named: String, inSb sbNamed: String) -> T? {
    return UIStoryboard(name: sbNamed, bundle: nil).instantiateViewController(withIdentifier: named) as? T
  }
}
