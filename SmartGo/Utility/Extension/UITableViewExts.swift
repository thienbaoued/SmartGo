//
//  UITableViewExts.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/16/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import Foundation
import UIKit
import DZNEmptyDataSet

extension UITableView {
  
  func setup(_ viewController: UIViewController) {
    self.delegate = viewController as? UITableViewDelegate
    self.dataSource = viewController as? UITableViewDataSource
  }
}
