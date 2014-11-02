//
//  ActivityModel.swift
//  Verb
//
//  Created by Jonathan Porta on 8/27/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class ActivityModel {
  var id: Int
  var type: String
  var activityMessage: String
  var message: MessageModel

  init(activity: JSON) {
    self.id = activity["id"].intValue
    self.type = activity["type"].stringValue
    self.activityMessage = activity["activity_message"].stringValue
    self.message = MessageModel(message: activity["message"])
  }
}
