//
//  MenuViewModel.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/6/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MenuViewModel {
  
  let auth = Auth.auth()
  var db = Firestore.firestore()
  
  var itemTitles = MenuItems.allCases.map({ $0.rawValue })
  var itemIconColors = MenuItems.allCases.map({$0.color})
  var itemIcons = MenuItemIcons.allCases.map({UIImage(named: $0.rawValue)!.withRenderingMode(.alwaysTemplate)})
  
  init() {
    db.setupFirebase()
  }
  
  public func getCurrentUser(completion: @escaping (User?) -> Void) {
    FirebaseAuthManger.shared.getCurrentUser(completion: { user in
      completion(user)
    })
  }
  
  public func signOut() {
    FirebaseAuthManger.shared.signOut()
  }
}
