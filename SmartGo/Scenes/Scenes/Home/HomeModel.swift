//
//  HomeModel.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/6/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import Foundation

class User {
  
  var id: String
  var firstName: String = ""
  var lastName: String = ""
  var email: String
  var birthday: String = ""
  var phone: Int = 0
  var address: String = ""
  
  var fullName: String {
    return firstName + " " + lastName
  }
  
  init(id: String, firstName: String, lastName: String, email: String, birthday: String, phone: Int, address: String) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.email = email
    self.birthday = birthday
    self.phone = phone
    self.address = address
  }
  
  init(dict: [String: Any]) {
    self.email = dict["email"] as? String ?? ""
    self.id = dict["id"] as? String ?? ""
    self.firstName = dict["firstName"] as? String ?? ""
    self.lastName = dict["lastName"] as? String ?? ""
    self.birthday = dict["birthday"] as? String ?? ""
    self.phone = dict["phone"] as? Int ?? 0
    self.address = dict["address"] as? String ?? ""
  }
}
