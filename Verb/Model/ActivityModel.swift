//
//  ActivityModel.swift
//  Verb
//
//  Created by Jonathan Porta on 8/27/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class ActivityModel: SwipeableModel {
  var id: Int?
  var type: String
  var activityMessage: String
  var reciprocateMessage: String
  var acknowledgeMessage: String
  var message: MessageModel?

  init(id: Int? = -1, type: String, activityMessage: String, reciprocateMessage: String? = "", acknowledgeMessage: String? = "", message: MessageModel? = nil) {
    self.id = id
    self.type = type
    self.activityMessage = activityMessage
    self.reciprocateMessage = reciprocateMessage!
    self.acknowledgeMessage = acknowledgeMessage!

    if message != nil {
      self.message = message
    }
  }

  convenience init(activity: JSON) {
    var id = activity["id"].intValue
    var type = activity["type"].stringValue
    var activityMessage = activity["activity_message"].stringValue
    var reciprocateMessage = activity["reciprocate_message"].stringValue
    var acknowledgeMessage = activity["acknowledge_message"].stringValue

    var message = MessageModel(message: activity["message"])

    self.init(id: id, type: type, activityMessage: activityMessage, reciprocateMessage: reciprocateMessage, acknowledgeMessage: acknowledgeMessage, message: message)
  }

  func isPlaceholder() -> Bool {
    if message == nil || id == -1 {
      return true
    }
    return false
  }

  func isAcknowledged() -> Bool {
    if !isPlaceholder(){
      if message?.acknowledgedAt > 0 { // TODO: Fix T.A.R.D.I.S. edgecase where no messages can be ack'd at the unix epoch.
        return true
      }
    }
    return false
  }

  func canAcknowledge() -> Bool {
    if isPlaceholder() || isAcknowledged() { // We can't ack a placeholder or an already ack'd message.
      return false
    }
    return type == "received"
  }

  func acknowledge() {
    if canAcknowledge() {
      message!.acknowledge()
      activityMessage = acknowledgeMessage // Temporarily update the activity message - gets overriden when actual server response is received.
      NSNotificationCenter.defaultCenter().postNotificationName("activity.update", object: nil)
    }
  }

  func canReciprocate() -> Bool {
    if isPlaceholder() || type == "sent" { // Doh! We can't reciprocate a placeholder or a sent message.
      return false
    }
    return true
  }

  func reciprocate() {
    if canReciprocate() {
      message!.reciprocate()
      var activity = ActivityModel(type: "sent", activityMessage: reciprocateMessage) // Provide a new, temporary Activity - gets overriden when actual server response is received.
      var userInfo: NSDictionary = ["activity": activity]
      NSNotificationCenter.defaultCenter().postNotificationName("activity.new", object: nil, userInfo: userInfo)
    }
  }

  func lastActionTimeAgoInWords() -> String {
    // TODO: Decide how the sublable text should change in each state
    if !isPlaceholder() {
      if type == "sent" {
        if isAcknowledged() { return "seen \(message!.createdAtInWords) ago" }
        return "sent \(message!.createdAtInWords) ago"
      }
      else {
        if isAcknowledged() { return "received \(message!.createdAtInWords) ago" }
        return "received \(message!.createdAtInWords) ago"
      }
    }
    else {
      return "sending..."
    }
  }

  // Implement the SwipeableModel Protocol
  func isSwipeable() -> Bool {
    return type == "received" && !isPlaceholder()
  }

  func promptMessage() -> String {
    return "\(message!.verb) back!"
  }

  func confirmMessage() -> String {
    return "Keep swiping to \(promptMessage())"
  }

  func workingMessage() -> String {
    return "about to \(message!.verb) \(message!.sender.firstName)!"
  }
}
