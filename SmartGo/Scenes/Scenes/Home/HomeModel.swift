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
  var fullName: String = ""
  var email: String
  var birthday: String = ""
  var phone: Int = 0
  var address: String = ""
  
  init(id: String, firstName: String, lastName: String, email: String, birthday: String, phone: Int, address: String) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.fullName = firstName + " " + lastName
    self.email = email
    self.birthday = birthday
    self.phone = phone
    self.address = address
  }
  
  init(email: String, id: String) {
    self.email = email
    self.id = id
  }
}
