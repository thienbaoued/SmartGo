//
//  UITextfieldEtxs.swift
//  Scooter
//
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
  func createTextfieldWithIcon(ic: UIImage) {
    let viewSize = self.frame.height
    let view = UIView(frame: CGRect(x: 0, y: 0, width: viewSize, height: viewSize))
    let imageView = UIImageView(image: ic)
    let iconSize = viewSize/2
    view.addSubview(imageView)
    imageView.frame = CGRect(x: iconSize/2, y: iconSize/2, width: iconSize, height: iconSize)
    self.leftViewMode = .always
    self.leftView = view
  }
}
