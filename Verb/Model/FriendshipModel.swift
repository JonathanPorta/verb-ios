//
//  FriendshipModel.swift
//  Verb
//
//  Created by Jonathan Porta on 8/27/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class FriendshipModel: Actionable {
  var id: Int
  var type: String
  var acknowledgedAt: Int
  var acknowlegedAtInWords: String
  var createdAt: Int
  var createdAtInWords: String
  var user: UserModel
  var friend: UserModel
  var activity: ActivityModel?

  init(actionable: JSON, activity: ActivityModel? = nil) {
    self.id = actionable["id"].intValue
    self.type = actionable["type"].stringValue
    self.acknowledgedAt = actionable["acknowledged_at"].intValue
    self.acknowlegedAtInWords = actionable["acknowleged_at_in_words"].stringValue
    self.createdAt = actionable["created_at"].intValue
    self.createdAtInWords = actionable["created_at_in_words"].stringValue
    self.user = UserModel(user: actionable["sender"])
    self.friend = UserModel(user: actionable["recipient"])

    if activity != nil {
      self.activity = activity
    }
  }

  // Implement Actionable
  func isAcknowledged() -> Bool {
    if acknowledgedAt > 0 { // TODO: Fix T.A.R.D.I.S. edgecase where no actionables can be ack'd at the unix epoch.
      return true
    }
    return false
  }

  func canAcknowledge() -> Bool {
    if isAcknowledged() { // We can't ack an already ack'd actionable.
      return false
    }
    return true
  }

  func acknowledge() {
    ConnectionFriendFactory.AcceptFriendship(self)
  }

  func canReciprocate() -> Bool {
    return false
  }

  func reciprocate() {

  }

  // Implement Swipeable
  func isSwipeable() -> Bool {
    return false
  }

  func promptMessage() -> String {
    return ""
  }

  func workingMessage() -> String {
    return ""
  }
}
