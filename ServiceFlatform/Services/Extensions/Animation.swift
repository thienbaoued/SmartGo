//
//  Animation.swift
//  ServicePlatform
//
//

import UIKit

public extension UIView {

  public typealias Action = () -> ()
  typealias Animation = (duration: TimeInterval, action: Action, completion: (() -> Void)? )
  /// Showing view on super view with fade animation
  ///
  /// - Parameter isShow: A flag to determine that this animation will be applied for show/hide view action
  /// - Parameter spring: A flag for willing use spring animation or not
  /// - Parameter completed: Callback when the animation was completed
  public func fadeAnimation(isShow: Bool = true, spring: Bool = false, duration: TimeInterval = 0.25, delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
    self.alpha = isShow ? 0 : 1
    let animation = (duration, { self.alpha = isShow ? 1: 0 }, completion)
    spring ? springAnimation(delay: delay, animation: animation) : defaultAnimation(delay: delay, animation: animation)
  }

  /// Basic animation with custom affection
  ///
  /// - Parameters:
  ///   - animation: effection
  ///   - completion: completion callback argument
  public func basicAnimation(_ animation: @escaping Action, duration: TimeInterval = 0.25, completion: (() -> Void)? = nil) {
    defaultAnimation(animation: (duration, animation, completion))
  }

  /// Executing change constraint's constant animation
  ///
  /// - Parameters:
  ///   - duration: animation duration
  ///   - action: action before executing animation
  public func layoutAnimation(duration: TimeInterval, action: @escaping Action) {
    action()
    UIView.animate(withDuration: duration) {
      self.layoutIfNeeded()
    }
  }

  /// Animation with spring effection
  ///
  /// - Parameter animation: Animation objects
  private func springAnimation(delay: TimeInterval = 0, animation: Animation) {
    UIView.animate(withDuration: animation.duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
      animation.action()
    }, completion: { _ in
      animation.completion?()
    })
  }

  /// Animation without any additional effection
  ///
  /// - Parameter animation: Animation objects
  private func defaultAnimation(delay: TimeInterval = 0, animation: Animation) {
    UIView.animate(withDuration: animation.duration, delay: delay, options: .curveEaseInOut, animations: {
      animation.action()
    }) { _ in
      animation.completion?()
    }
  }

  /// Animation to rotate view
  ///
  /// - Parameters:
  ///   - rad: degrees of rotation
  ///   - duration: animation duration
  public func rotateAnimation(rad: CGFloat = .pi * 2, duration: TimeInterval = 0.5) {
    /// For safe, clean up all animations before adding new one.
    layer.removeAllAnimations()
    /// Initial rotation layer animation and add it into specified view
    let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
    rotateAnimation.fromValue = 0.0
    rotateAnimation.toValue = rad
    rotateAnimation.duration = duration
    rotateAnimation.repeatCount = Float.infinity
    rotateAnimation.isRemovedOnCompletion = false
    layer.add(rotateAnimation, forKey: "rotationAnimation")
  }

  /// Animation for location dialog
  ///
  /// - Parameters:
  ///   - duration: duration animation
  ///   - delay: delay time
  ///   - scale: scale value
  public func locationAnimation(duration: TimeInterval = 2, delay: TimeInterval = 0, scale: CGFloat = 0 ) {
    self.layer.transform = CATransform3DIdentity
    self.layer.removeAllAnimations()

    UIView.animate(withDuration: duration, delay: delay, options: .repeat, animations: {
      self.transform = CGAffineTransform(scaleX: scale, y: scale)
    }, completion: {(finished: Bool) in
      self.transform = CGAffineTransform(scaleX: 0, y: 0)
    })
  }

  /// Move animation
  ///
  /// - Parameters:
  ///   - duration: animation duration
  ///   - delay: delay time
  public func moveAnimation(duration: TimeInterval, delay: TimeInterval) {
    UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveLinear, animations: {
      self.frame.origin.x += 250
      self.frame.origin.y += 100
    }, completion: nil)
  }

  /// Rotate animation and no repeat for mask image
  ///
  /// - Parameters:
  ///   - duration: animation duration
  ///   - delay: delay time
  public func rotateAnimationMask(duration: TimeInterval, delay: TimeInterval) {
    UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
      self.transform = CGAffineTransform(rotationAngle: .pi/6)
    }, completion: nil)
  }

  /// Shake the animation
  ///
  /// - Parameters:
  ///   - duration: animation duration
  public func shake(duration: CFTimeInterval = 0.01, repeatCount: Float = Float.infinity, reverse: Bool = true, values: [Any]? = nil) {
    /// Clean previous animation for safe
    layer.removeAnimation(forKey: "shakeIt")

    /// Start initializing new one
    let transformAnim  = CAKeyframeAnimation(keyPath:"transform")
    transformAnim.autoreverses = reverse
    transformAnim.duration  = duration
    transformAnim.repeatCount = repeatCount
    transformAnim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    transformAnim.values = values ?? [CATransform3DMakeRotation(-0.05, 0, 0, 1.0), CATransform3DMakeRotation(0.06, 0.0, 0.0, 1.0)]
    transformAnim.isRemovedOnCompletion = false
    self.layer.add(transformAnim, forKey: "shakeIt")
  }

  /// Hide animation
  ///
  /// - Parameters:
  ///   - duration: animation duration
  ///   - delay: delay time
  public func hideAnimation(duration: TimeInterval, delay: TimeInterval, completion: Action? = nil) {
    UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
      self.alpha = 0
    }, completion: { _ in
      completion?()
    })
  }

  /// Zoom animation
  ///
  /// - Parameters:
  ///   - duration: animation duration
  ///   - delay: delay time
  ///   - scaleX: value of scaleX
  ///   - scaleY: value of scaleY
  public func zoomAnimation(duration: TimeInterval, delay: TimeInterval, scaleX: CGFloat, scaleY: CGFloat, completion: Action? = nil) {
    self.alpha = 1
    self.transform = CGAffineTransform(scaleX: 0, y: 0)
    UIView.animate(withDuration: 0.25, delay: 0.25, options: UIView.AnimationOptions.curveEaseIn, animations: {
      self.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
    }, completion: { _ in
      completion?()
    })
  }

  /// Slide in left and right animation
  ///
  /// - Parameters:
  ///   - duration: animation duration
  ///   - isLeft: slide in left if true and slide in right if false
  public func slideInAnimation(duration: Double = 1, subType: CATransitionSubtype = CATransitionSubtype.fromBottom) {
    alpha = 1
    let animate = CATransition()
    animate.type = CATransitionType.push
    animate.subtype = subType
    animate.duration = duration
    animate.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    animate.fillMode = CAMediaTimingFillMode.removed
    self.layer.add(animate, forKey: "slideInAnimation")
  }
}
