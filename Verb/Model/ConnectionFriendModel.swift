//
//  ConnectionFriendModel.swift
//  Verb
//
//  Created by Jonathan Porta on 8/28/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class ConnectionFriendModel: UserModel {
  var relationship: String

  override init(user: JSON) {
    relationship = user["relationship"].stringValue
    super.init(user: user)
  }

  func requestFriendship() {
    if relationship == "not friends" {
      //Set a temporary value to help with UI lag
      relationship = "friendship requested"
      ConnectionFriendFactory.RequestFriendship(self)
    }
  }
}
