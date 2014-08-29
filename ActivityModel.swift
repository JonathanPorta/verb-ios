//
//  ActivityModel.swift
//  Verb
//
//  Created by Jonathan Porta on 8/27/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class ActivityModel {
  var userId: NSInteger
  var messageId: NSInteger
  var body: NSString
  var acknowledgedAt: NSDate
  var createdAt: NSDate
  var updatedAt: NSDate
  
  init(userId:Int, messageId:Int, body:String, acknowledgedAt:NSDate, createdAt:NSDate, updatedAt:NSDate) {
    self.userId = userId
    self.messageId = messageId
    self.body = body
    self.acknowledgedAt = acknowledgedAt
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }

}