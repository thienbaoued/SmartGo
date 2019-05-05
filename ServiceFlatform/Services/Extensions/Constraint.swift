//
//  Constraint.swift
//  ServicePlatform
//
//

// MARK: - NSLayoutConstraint
public extension NSLayoutConstraint {

  /// Changing multiplier constraint
  ///
  /// - Parameter multiplier: multiplier value of constraint
  /// - Returns: NSLayoutConstraint object
  public func setMultiplier(multiplier: CGFloat, cpriority: Float = 1000) -> NSLayoutConstraint {
    NSLayoutConstraint.deactivate([self])
    guard let firstItem = firstItem else { return NSLayoutConstraint() }

    let newConstraint = NSLayoutConstraint(
      item: firstItem,
      attribute: firstAttribute,
      relatedBy: relation,
      toItem: secondItem,
      attribute: secondAttribute,
      multiplier: multiplier,
      constant: constant)

    newConstraint.priority = UILayoutPriority(rawValue: cpriority)
    newConstraint.shouldBeArchived = self.shouldBeArchived
    newConstraint.identifier = self.identifier

    NSLayoutConstraint.activate([newConstraint])
    return newConstraint
  }
}
