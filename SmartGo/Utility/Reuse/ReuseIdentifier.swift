import Foundation

protocol ReuseIdentifier {
  static var identifier: String { get }
}

extension ReuseIdentifier {
  static var identifier: String {
    return String(describing: Self.self)
  }
}
