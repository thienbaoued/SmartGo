import Foundation
import UIKit

protocol ReuseNib: ReuseIdentifier {
  static var nib: UINib { get }
}

extension ReuseNib {
  static var nib: UINib {
    return UINib(nibName: identifier, bundle: nil)
  }
}
