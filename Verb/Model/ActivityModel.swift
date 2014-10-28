//
//  ActivityModel.swift
//  Verb
//
//  Created by Jonathan Porta on 8/27/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation
import SwiftyJSON

class ActivityModel {
  var id: Int
  var type: String
  var activityMessage: String
  var message: MessageModel
  
  init(activity: JSON, message: MessageModel) {
    self.id = activity["id"].intValue
    self.type = activity["type"].stringValue
    self.activityMessage = activity["activity_message"].stringValue
    self.message = message

    //self.message = MessageModel(message: JSON(object: activity["messsage"]!.object))
  }
}


//{
//  "id": 14,
//  "type": "received",
//  "activity_message": "Jessica slapped you.",
//  "message": {
//    "id": 9,
//    "verb": "slap",
//    "sender": {
//      "id": 1,
//      "email": "volleygirl1005@gmail.com",
//      "first_name": "Jessica",
//      "last_name": "Porta"
//    },
//    "recipient": {
//      "id": 2,
//      "email": "wjporta@hotmail.com",
//      "first_name": "Jonathan",
//      "last_name": "Porta"
//    },
//    "acknowledged_at": 1411939218,
//    "acknowledged_at_in_words": "6 days",
//    "created_at": 1411928464,
//    "created_at_in_words": "6 days"
//  }
//},