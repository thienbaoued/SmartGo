//
//  FirebaseExts.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/7/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import Foundation
import Firebase

var db = Firestore.firestore()

extension Firestore {
  func setupFirebase() {
    db.settings.areTimestampsInSnapshotsEnabled = true
  }
}

