//
//  SignInViewModel.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/7/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import Foundation
import Firebase

class SignInViewModel {
  
  let auth = Auth.auth()
  var db = Firestore.firestore()
  
  init() {
    db.setupFirebase()
  }
  
  public func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
    FirebaseAuthManger.shared.signIn(email: email, password: password, completion: { check in
      completion(check)
    })
  }
  
  public func checkValueIsEmpty(email: String, password: String) -> Bool {
    if email.isEmpty || password.isEmpty{
      return true
    }
    return false
  }
  
  public func notificationTextField(text: String, of textField: UserProfileTextField) -> String {
    return text.isEmpty ? "* \(textField.rawValue) must not be empty" : ""
  }
}
