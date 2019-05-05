//
//  UIImageViewExts.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/5/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
  func loadImageFromURL(_ url: String, cropTo size: CGSize? = nil) {
    guard let url = URL(string: url) else { return }
    if let size = size {
      kf.setImage(with: url, options: [.processor(CroppingImageProcessor(size: size))])
    } else {
      kf.setImage(with: url)
    }
  }
}
