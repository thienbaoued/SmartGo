//
//  FirebaseAuthManager.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/9/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import Foundation
import Firebase

class FirebaseAuthManger {
  
  let auth = Auth.auth()
  var db = Firestore.firestore()
  
  static let shared = FirebaseAuthManger()
  
  init() {
    db.setupFirebase()
  }
  
  public func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
    auth.signIn(withEmail: email, password: password) { user, error in
      if let error = error {
        print(error)
        completion(false)
      } else {
        NotificationCenter.default.post(name: Notification.Name.reloadMenu, object: nil)
        completion(true)
      }
    }
  }
  
  public func signOut() {
    try! auth.signOut()
  }
  
  public func register(email: String, password: String, completion: @escaping (Bool) -> Void) {
    auth.createUser(withEmail: email, password: password) { user, error in
      if let error = error {
        print(error)
        completion(false)
      } else {
        guard let user = self.auth.currentUser else { return }
        guard let email = user.email else { return }
        
        let data: [String: Any] = [
          "firstName" : "",
          "lastName" : "",
          "email" : email,
          "id" : user.uid,
          "phone" : 0,
          "birthday" : "",
          "address" : ""
        ]
        
        FirestoreCollection.user.document(user.uid).setData(data)
        completion(true)
      }
    }
  }
  
  public func getCurrentUser(completion: @escaping (User?) -> Void) {
    if let currentUser = auth.currentUser {
      let id = currentUser.uid
      FirestoreCollection.user.whereField(UserCollection.id.rawValue, isEqualTo: id).getDocuments { (snapshot, error) in
        if let error = error {
          print(error)
        } else {
          guard let document = snapshot?.documents.first else { return }
          let user = User(dict: document.data())
          print(document.data())
          completion(user)
        }
      }
    } else {
      completion(nil)
    }
  }
  
  public func isCurrentUser(completion: @escaping (Bool) -> Void) {
    if auth.currentUser != nil {
      completion(true)
    } else {
      completion(false)
    }
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
}
