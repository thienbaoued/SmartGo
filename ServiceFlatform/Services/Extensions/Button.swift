//
//  Button.swift
//  ServicePlatform
//
//

import RxCocoa

public extension UIButton {

  /// Convenient function for making a Rx driver of Button
  ///
  /// - Returns: Rx driver
  public func driver() -> Driver<Void> {
    return rx.tap.asDriver()
  }
}
