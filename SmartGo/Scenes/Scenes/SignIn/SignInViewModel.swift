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
  
  public func checkUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
    auth.signIn(withEmail: email, password: password) { user, error in
      if let error = error {
        print(error)
        completion(false)
      } else {
        completion(true)
      }
    }
  }
  
  public func checkValueIsEmpty(email: String, password: String) -> Bool {
    if email.isEmpty && password.isEmpty{
      return true
    } else if password.isEmpty {
      return true
    } else if email.isEmpty  {
      return true
    }
    return false
  }
  
  public func stateTextField(text: String, of textField: UserProfileTextField) -> String {
    return text.isEmpty ? "*\(textField.rawValue) must not be empty" : ""
  }
}
