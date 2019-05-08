//
//  Struct.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/6/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct Icons {
  static let back = UIImage(named: "go-back")
  static let search = UIImage(named: "ic-search")
  static let dropDown = UIImage(named: "drop-down")
  static let user = UIImage(named: "ic-user")
  static let menu = UIImage(named: "ic-menu")
  static let clear = UIImage(named: "ic-clear")
  static let reset = UIImage(named: "ic-reset")
  static let facebook = UIImage(named: "ic-fb")
  static let google = UIImage(named: "ic-gg")
}

struct FirestoreCollection {
  static let user = db.collection("User")
}
