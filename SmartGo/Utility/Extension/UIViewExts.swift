//
//  UIViewExts.swift
//  Timo
//
//  Copyright © 2018 Timo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  
  func animated(color: UIColor, time: TimeInterval = 3.0) {
    self.backgroundColor = color
    UIView.animate(withDuration: time, animations: { [weak self] in
      self?.backgroundColor = .white
    }) { [weak self] _ in
      self?.backgroundColor = .white
    }
  }
  
  func addBorder(edge: UIRectEdge, borderColor: UIColor, thickness: CGFloat, ratio: CGFloat = 0) {
    let border = CALayer()
    let width = self.frame.size.width
    let height = self.frame.size.height
    let positionLine: CGFloat
    border.backgroundColor = borderColor.cgColor
    self.layer.addSublayer(border)
    
    switch edge {
    case .top:
      positionLine = ratio==1 ? 0 : (width-width/ratio)/2
      border.frame = CGRect(x: positionLine,y: 0, width:width/ratio, height: thickness)
    case .bottom:
      positionLine = ratio==1 ? 0 : (width-width/ratio)/2
      border.frame = CGRect(x: positionLine,y: height-thickness, width:width/ratio, height: thickness)
    case . left:
      positionLine = ratio==1 ? 0 : (height-height/ratio)/2
      border.frame = CGRect(x: thickness,y: positionLine, width:thickness, height: height/ratio)
    case .right:
      positionLine = ratio==1 ? 0 : (height-height/ratio)/2
      border.frame = CGRect(x: width - thickness,y: positionLine, width:thickness, height: height/ratio)
    default:
      self.layer.borderWidth = thickness
      self.layer.borderColor = borderColor.cgColor
    }
  }
  
  func cornerAndShadow() {
    // Circle image
    self.layer.cornerRadius = self.frame.size.width/2
    self.layer.masksToBounds = true
    self.clipsToBounds = true
    
    // Shadow image
    self.layer.shadowColor = UIColor.white.cgColor
    self.layer.shadowOpacity = 1
    self.layer.shadowOffset = .zero
    self.layer.shadowRadius = 10
    self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    self.layer.shouldRasterize = true
  }
  
  func corner(value: CGFloat) {
    self.layer.cornerRadius = value
    self.layer.masksToBounds = true
  }
}
