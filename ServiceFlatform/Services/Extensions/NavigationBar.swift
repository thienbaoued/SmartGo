//
//  NavigationBar.swift
//  ServicePlatform
//
//

public extension UINavigationBar {

  public func setGradientBackground(colors: [UIColor]) {

    var updatedFrame = bounds
    updatedFrame.size.height += UIApplication.shared.statusBarFrame.height
    let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
    barTintColor = UIColor(patternImage: gradientLayer.createGradientImage()!)
    isTranslucent = false
//    setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
  }
  
  public func removeBottomLine() {
    self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.shadowImage = UIImage()
  }
}

public extension UISearchBar {
  
  private func getViewElement<T>(type: T.Type) -> T? {
    
    let svs = subviews.flatMap { $0.subviews }
    guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
    return element
  }
  
  func getSearchBarTextField() -> UITextField? {
    
    return getViewElement(type: UITextField.self)
  }
  
  func setPlaceholderTextColor(color: UIColor) {
    
    if let textField = getSearchBarTextField() {
      textField.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: color])
    }
  }
  
  func setTextColor(color: UIColor) {
    
    if let textField = getSearchBarTextField() {
      textField.textColor = color
    }
  }
}
