//
//  UserModel.swift
//  Verb
//
//  Created by Jonathan Porta on 8/28/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class UserModel: SelectableModel {
  var id: Int
  var email: String
  var firstName: String
  var lastName: String

  init(id: Int, email: String, firstName: String, lastName: String) {
    self.id = id
    self.email = email
    self.firstName = firstName
    self.lastName = lastName
  }
}

//    "sender": {
//      "id": 1,
//      "email": "volleygirl1005@gmail.com",
//      "first_name": "Jessica",
//      "last_name": "Porta"
//    },
