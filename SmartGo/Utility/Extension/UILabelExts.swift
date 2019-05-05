//
//  UILabelExts.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/5/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
  func rangeTextAttributes(strings: [String]) {
    let regularStringAttribute: [NSAttributedString.Key : Any] = [
      .font: UIFont.systemFont(ofSize: 17, weight: .light)
    ]
    
    let boldStringAttribute: [NSAttributedString.Key : Any] = [
      .font: UIFont.boldSystemFont(ofSize: 17)
    ]
    
    let attribute = NSMutableAttributedString()
    strings.enumerated().map {(string: $0.element, attribute: $0.offset % 2 == 0 ? regularStringAttribute : boldStringAttribute)}.forEach {attribute.append(NSAttributedString(string: $0.string, attributes: $0.attribute))}
    self.attributedText = attribute
    self.textAlignment = .left
  }
}
