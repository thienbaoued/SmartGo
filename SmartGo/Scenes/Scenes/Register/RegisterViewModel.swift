//
//  RegisterViewModel.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/8/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import Foundation
import Firebase

class RegisterViewModel {
  
  let auth = Auth.auth()
  var db = Firestore.firestore()
  
  init() {
    db.setupFirebase()
  }
  
  public func register(email: String, password: String, completion: @escaping (Bool) -> Void) {
    FirebaseAuthManger.shared.register(email: email, password: password, completion: { check in
      completion(check)
    })
  }
  
  public func checkValueIsEmpty(email: String, password: String, confirmPassword: String) -> Bool {
    if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
      return true
    }
    return false
  }
  
  public func checkUserExists(email: String, completion: @escaping (Bool) -> Void) {
    FirebaseAuthManger.shared.checkUserExists(email: email, completion: { check in
      completion(check)
    })
  }
  
  public func checkPasswordIsMatch(password: String, confirmPassword: String) -> Bool {
    return password==confirmPassword
  }
  
  public func notificationTextField(text: String = "", of textField: UserProfileTextField) -> String {
    return text.isEmpty ? "* \(textField.rawValue) must not be empty" : ""
  }
}
