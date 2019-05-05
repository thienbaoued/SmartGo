//
//  BarButtonItem.swift
//  ServicePlatform
//
//

import RxCocoa

public extension UIBarButtonItem {
  
  /// Convenient function for making a Rx driver of BarButtonItem
  ///
  /// - Returns: Rx driver
  public func driver() -> Driver<Void> {
    return rx.tap.asDriver()
  }
}
