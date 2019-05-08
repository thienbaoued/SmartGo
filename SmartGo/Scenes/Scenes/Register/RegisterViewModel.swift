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
  
  public func register(email: String, password: String) {
    auth.createUser(withEmail: email, password: password) { user, error in
      if let error = error {
        print(error)
      } else {
        guard let user = self.auth.currentUser else { return }
        guard let email = user.email else { return }
        
        let data: [String: Any] = [
          "firstName" : "",
          "lastName" : "",
          "fullName" : "",
          "email" : email,
          "id" : user.uid,
          "phone" : 0,
          "birthday" : "",
          "address" : ""
        ]
        
        FirestoreCollection.user.document(user.uid).setData(data)
      }
    }
  }
  
  public func checkValueIsEmpty(email: String, password: String, confirmPassword: String) -> Bool {
    if email.isEmpty && password.isEmpty && confirmPassword.isEmpty {
      return true
    } else if email.isEmpty && password.isEmpty {
      return true
    } else if password.isEmpty && confirmPassword.isEmpty  {
      return true
    } else if email.isEmpty && confirmPassword.isEmpty {
      return true
    } else if email.isEmpty {
      return true
    } else if password.isEmpty {
      return true
    } else if confirmPassword.isEmpty {
      return true
    }
    return false
  }
  
  public func checkUserExists(email: String, completion: @escaping (Bool) -> Void) {
    FirestoreCollection.user.whereField(UserCollection.email.rawValue, isEqualTo: email).getDocuments{ (snapshot, error) in
      if let error = error {
        print(error)
      } else {
        guard let count = snapshot?.documents.count else { return }
        print(count)
        if count > 0 {
          completion(false)
        } else {
          completion(true)
        }
      }
    }
  }
  
  public func checkPasswordIsMatch(password: String, confirmPassword: String) -> Bool {
    return password==confirmPassword
  }
  
  public func stateTextField(text: String = "", of textField: UserProfileTextField) -> String {
    return text.isEmpty ? "*\(textField.rawValue) must not be empty" : ""
  }
}
