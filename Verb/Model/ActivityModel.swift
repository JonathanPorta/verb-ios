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

  init(activity: JSON, message: MessageModel) {
    self.id = activity["id"].intValue
    self.type = activity["type"].stringValue
    self.activityMessage = activity["activity_message"].stringValue
    self.message = message
  }
}

class Activity: VerbAPIProtocol, VerbAPIModelProtocol {

  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

  class var sharedInstance: Activity {
    struct Static {
      static let instance: Activity = Activity(endpoint: "activities.json")
    }
    return Static.instance
  }

  var endpoint: String

  init(endpoint: String) {
    self.endpoint = endpoint
  }

  func New(properties: [String: AnyObject]) {

  }

  func All() {
    var verbAPI = appDelegate.getVerbAPI()
    verbAPI.getActivities(self)
  }

  func didReceiveResult(result: JSON) {
    var activities: NSMutableArray = []

    NSLog("Activity.didReceiveResult: \(result)")

    for (index: String, activity: JSON) in result {
      // Wow, this sucks.

      var msg = activity["message"]
      var sndr = msg["sender"]

      println(sndr["id"].intValue)
      println(msg)

      var senderUserModel = UserModel(
        id: activity["message"]["sender"]["id"].intValue,
        email: activity["message"]["sender"]["email"].stringValue,
        firstName: activity["message"]["sender"]["first_name"].stringValue,
        lastName: activity["message"]["sender"]["last_name"].stringValue
      )

      var recipientUserModel = UserModel(
        id: activity["message"]["recipient"]["id"].intValue,
        email: activity["message"]["recipient"]["email"].stringValue,
        firstName: activity["message"]["recipient"]["first_name"].stringValue,
        lastName: activity["message"]["recipient"]["last_name"].stringValue
      )

      var messageModel = MessageModel(
        id: activity["message"]["id"].intValue,
        verb: activity["message"]["verb"].stringValue,
        acknowledgedAt: activity["message"]["acknowledged_at"].intValue,
        acknowlegedAtInWords: activity["message"]["acknowledged_at_in_words"].stringValue,
        createdAt: activity["message"]["created_at"].intValue,
        createdAtInWords: activity["message"]["created_at_in_words"].stringValue,
        sender: senderUserModel,
        recipient: recipientUserModel
      )

      var activityModel = ActivityModel(activity: activity, message: messageModel)
      activities.addObject(activityModel)
    }

    var userInfo: NSDictionary = ["activities": activities]
    NSNotificationCenter.defaultCenter().postNotificationName("newActivityData", object: nil, userInfo: userInfo)
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
