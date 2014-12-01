//
//  ConnectionFriendModel.swift
//  Verb
//
//  Created by Jonathan Porta on 8/28/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class ConnectionFriendModel: UserModel {
  var isFriend: Bool

  override init(user: JSON) {
    self.isFriend = user["is_friend"].boolValue
    super.init(user: user)
  }

  func requestFriendship() {
    if !isFriend {
      ConnectionFriendFactory.RequestFriendship(self)
    }
  }
}
