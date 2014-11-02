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

  init(user: JSON) {
    self.id = user["id"].intValue
    self.email = user["email"].stringValue
    self.firstName = user["first_name"].stringValue
    self.lastName = user["last_name"].stringValue
  }
}
