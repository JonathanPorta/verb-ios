//
//  ActivityModel.swift
//  Verb
//
//  Created by Jonathan Porta on 8/27/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class ActivityModel: Swipeable {
  var id: Int?
  var type: String
  var activityMessage: String
  var reciprocateMessage: String
  var acknowledgeMessage: String
  var actionable: Actionable?

  init(id: Int? = -1, type: String, activityMessage: String, reciprocateMessage: String? = "", acknowledgeMessage: String? = "", actionable: Actionable? = nil) {
    self.id = id
    self.type = type
    self.activityMessage = activityMessage
    self.reciprocateMessage = reciprocateMessage!
    self.acknowledgeMessage = acknowledgeMessage!

    if actionable != nil {
      self.actionable = actionable
    }
  }

  convenience init(activity: JSON) {
    var id = activity["id"].intValue
    var type = activity["type"].stringValue
    var activityMessage = activity["activity_message"].stringValue
    var reciprocateMessage = activity["reciprocate_message"].stringValue
    var acknowledgeMessage = activity["acknowledge_message"].stringValue

    var actionableModel = FriendshipModel(actionable: activity["actionable"]) as Actionable

    if(activity["actionable"]["type"].stringValue == "Message"){
      actionableModel = MessageModel(actionable: activity["actionable"]) as Actionable
    }

    self.init(id: id, type: type, activityMessage: activityMessage, reciprocateMessage: reciprocateMessage, acknowledgeMessage: acknowledgeMessage, actionable: actionableModel)
  }

  func isPlaceholder() -> Bool {
    if actionable == nil || id == -1 {
      return true
    }
    return false
  }


  func lastActionTimeAgoInWords() -> String {
    // TODO: Decide how the sublable text should change in each state
    if !isPlaceholder() {
      if type == "sent" {
        if isAcknowledged() { return "seen \(actionable!.createdAtInWords) ago" }
        return "sent \(actionable!.createdAtInWords) ago"
      }
      else {
        if isAcknowledged() { return "received \(actionable!.createdAtInWords) ago" }
        return "received \(actionable!.createdAtInWords) ago"
      }
    }
    else {
      return "sending..."
    }
  }

  func isAcknowledged() -> Bool {
    if !isPlaceholder() {
      return actionable!.isAcknowledged()
    }
    return false
  }

  func canAcknowledge() -> Bool {
    if isPlaceholder() || actionable!.isAcknowledged() { // We can't ack a placeholder
      return false
    }
    return type == "received"
  }

  func acknowledge() {
    if canAcknowledge() {
      actionable!.acknowledge()
      activityMessage = acknowledgeMessage // Temporarily update the activity actionable - gets overriden when actual server response is received.
      NSNotificationCenter.defaultCenter().postNotificationName("activity.update", object: nil)
    }
  }

  func canReciprocate() -> Bool {
    if isPlaceholder() || type == "sent" { // Doh! We can't reciprocate a placeholder or a sent actionable.
      return false
    }
    return true
  }

  func reciprocate() {
    if canReciprocate() {
      actionable!.reciprocate()
      var activity = ActivityModel(type: "sent", activityMessage: reciprocateMessage) // Provide a new, temporary Activity - gets overriden when actual server response is received.
      var userInfo: NSDictionary = ["activity": activity]
      NSNotificationCenter.defaultCenter().postNotificationName("activity.new", object: nil, userInfo: userInfo)
    }
  }

  // Implement the SwipeableModel Protocol
  func isSwipeable() -> Bool {
    if !isPlaceholder() {
      return type == "received" && actionable!.isSwipeable()
    }
    else {
      return false
    }
  }

  func promptMessage() -> String {
    return actionable!.promptMessage()
  }

  func workingMessage() -> String {
    return actionable!.workingMessage()
  }
}
