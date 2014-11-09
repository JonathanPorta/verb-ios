//
//  MessageModel.swift
//  Verb
//
//  Created by Jonathan Porta on 8/27/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class MessageModel {
  var id: Int
  var verb: String
  var acknowledgedAt: Int
  var acknowlegedAtInWords: String
  var createdAt: Int
  var createdAtInWords: String
  var sender: UserModel
  var recipient: UserModel
  var activity: ActivityModel?

  init(message: JSON, activity: ActivityModel? = nil) {
    self.id = message["id"].intValue
    self.verb = message["verb"].stringValue
    self.acknowledgedAt = message["acknowledged_at"].intValue
    self.acknowlegedAtInWords = message["acknowleged_at_in_words"].stringValue
    self.createdAt = message["created_at"].intValue
    self.createdAtInWords = message["created_at_in_words"].stringValue
    self.sender = UserModel(user: message["sender"])
    self.recipient = UserModel(user: message["recipient"])

    if activity != nil {
      self.activity = activity
    }
  }

  func acknowledge() {
    MessageFactory.Acknowledge(self)
  }

  func reciprocate() {
    MessageFactory.Reciprocate(self)
  }
}