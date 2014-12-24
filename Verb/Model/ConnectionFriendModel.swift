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
  var isHidden: Bool

  override init(user: JSON) {
    isFriend = user["is_friend"].boolValue
    self.isHidden = false
    super.init(user: user)
  }

  func friendshipStatusIcon() -> String {
    // TODO: Make this actually return a relevant icon.
    return "\u{e850}"
  }

  func friendshipStatusColor() -> UIColor {
    return UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
  }

  func requestFriendship() {
    if !isFriend {
      ConnectionFriendFactory.RequestFriendship(self)
    }
  }
}
