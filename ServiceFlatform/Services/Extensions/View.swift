//
//  View.swift
//  ServicePlatform
//
//

import UIKit

// MARK: - UIView
public extension UIView {

  public func snapshot() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
    drawHierarchy(in: bounds, afterScreenUpdates: true)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
  }

  public func roundBorder(radius: CGFloat, width: CGFloat = 0, color: CGColor = UIColor.clear.cgColor, corners: UIRectCorner = .allCorners) {
    if corners == .allCorners {
      self.layer.cornerRadius = radius
      self.layer.borderWidth = width
      self.layer.borderColor = color
      self.layer.masksToBounds = true
    } else {
      let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
      let shapeLayer = CAShapeLayer()
      shapeLayer.frame = bounds
      shapeLayer.path = maskPath.cgPath
      shapeLayer.borderColor = color
      shapeLayer.borderWidth = width
      layer.mask = shapeLayer
    }
  }

  public func dashedBorder(radius: CGFloat, width: CGFloat = 0, color: CGColor = UIColor.clear.cgColor) {
    let  borderLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

    borderLayer.bounds=shapeRect
    borderLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
    borderLayer.fillColor = UIColor.clear.cgColor
    borderLayer.strokeColor = color
    borderLayer.lineWidth = width
    borderLayer.cornerRadius = radius
    borderLayer.masksToBounds = true
    borderLayer.lineJoin = CAShapeLayerLineJoin.round
    borderLayer.lineDashPattern = NSArray(array: [NSNumber(value: 5), NSNumber(value:5)]) as? [NSNumber]

    let path = UIBezierPath.init(roundedRect: shapeRect, cornerRadius: 0)
    borderLayer.path = path.cgPath
    self.layer.addSublayer(borderLayer)
  }

  public func makeCircle() {
    self.layer.cornerRadius = self.width/2
    self.layer.masksToBounds = true
  }

  public func makeShadow(opacity: Float = 0.5, radius: CGFloat = 2, height: CGFloat = 3, color: UIColor = .gray, bottom: Bool = true, all: Bool = false) {
    self.layer.shadowOpacity = opacity
    self.layer.shadowRadius = radius
    self.layer.shadowColor = color.cgColor
    if all {
      self.layer.shadowOffset = .zero
    } else {
      let offset = bottom ? CGSize(width: 0, height: height): CGSize(width: height, height: 0)
      self.layer.shadowOffset = offset
    }
    self.layer.masksToBounds = false
  }

  public func rotateCycle() {
    rotateAnimation(rad: .pi * 2, duration: 0.5)
  }

  static public func createIndicator() -> UIImageView {
    let indicator = UIImageView(image: #imageLiteral(resourceName: "animLoadingGray"))
    indicator.size = CGSize(width: 30, height: 30)
    return indicator
  }

  public func initializeIndicator(height: CGFloat = 50) -> UIView {
    let indicator = UIView.createIndicator()

    let seemoreView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
    seemoreView.backgroundColor = .clear
    indicator.center = seemoreView.center
    seemoreView.addSubview(indicator)
    indicator.rotateAnimation(rad: .pi * 2, duration: 0.5)
    return seemoreView
  }

  public func isKind(classNamed: String) -> Bool {
    if let targetClass = NSClassFromString(classNamed) {
      return self.isKind(of: targetClass)
    }
    return false
  }

  /// Convert origin point of sender's superview into another view's superview
  ///
  /// - Parameters:
  ///   - sender: target view
  ///   - view: destination view
  /// - Returns: converted point
  public func convertOrigin(to view: UIView) -> CGPoint? {
    let sp2View = superview?.superview
    if let point1 = superview?.convert(frame.origin, to: sp2View),
      let point = sp2View?.convert(point1, to: view){
      return point
    }
    return nil
  }

  /// A common public function for loading view from nib
  ///
  /// - Returns: a view
  @discardableResult
  public func fromNib<T: UIView>() -> T? {
    guard let view = UINib(nibName: String(describing: type(of: self)), bundle: nil).instantiate(withOwner: self, options: nil).first as? T else {
      return nil
    }

    view.frame = bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(view)
    return view
  }

  public var x: CGFloat {
    get { return self.frame.x }
    set { self.frame.x = newValue }
  }

  public var y: CGFloat {
    get { return self.frame.y }
    set { self.frame.y = newValue }
  }

  public var width: CGFloat {
    get { return self.frame.width }
    set { self.frame.size.width = newValue }
  }

  public var height: CGFloat {
    get { return self.frame.height }
    set { self.frame.size.height = newValue }
  }

  public var size: CGSize {
    get { return self.frame.size }
    set { self.frame.size = newValue }
  }

  public var origin: CGPoint {
    get { return self.frame.origin }
    set { self.frame.origin = newValue }
  }

  public var addSize: CGFloat {
    get { return 0 }
    set {
      width += newValue
      height += newValue
    }
  }
}

// Getting frame's components
public extension CGRect {

  public var x: CGFloat {
    get { return self.origin.x }
    set { self.origin.x = newValue }
  }

  public var y: CGFloat {
    get { return self.origin.y }
    set { self.origin.y = newValue }
  }

  public var doubleSize: CGSize {
    get { return CGSize(width: size.width * 2, height: size.height * 2) }
    set { self.size = newValue }
  }

  public var addSize: CGFloat {
    get { return 0 }
    set {
      size.width += newValue
      size.height += newValue
    }
  }
  public var subOrigin: CGFloat {
    get { return 0 }
    set {
      x -= newValue
      y -= newValue
    }
  }
}

extension CGSize {

  public func math(_ f: (CGFloat, CGFloat) -> CGFloat, _ x: CGFloat) -> CGSize {
    return CGSize(width: f(width, x), height: f(height, x))
  }
}
