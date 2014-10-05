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
  
  init(id: Int, verb: String, acknowledgedAt: Int, acknowlegedAtInWords: String, createdAt: Int, createdAtInWords: String, sender: UserModel, recipient: UserModel) {
    self.id = id
    self.verb = verb
    self.acknowledgedAt = acknowledgedAt
    self.acknowlegedAtInWords = acknowlegedAtInWords
    self.createdAt = createdAt
    self.createdAtInWords = createdAtInWords
    self.sender = sender
    self.recipient = recipient

//    self.id = message["id"].integerValue
//    self.verb = message["verb"].stringValue
//    self.acknowledgedAt = message["acknowledged_at"].integerValue
//    self.acknowlegedAtInWords = message["acknowledged_at_in_words"].stringValue
//    self.createdAt = message["created_at"].integerValue
//    self.createdAtInWords = message["created_at_in_words"].stringValue

    //self.sender = UserModel(user: message["sender"]!.dictionaryValue)
    //self.recipient = UserModel(user: message["recipient"]!.dictionaryValue)
  }
  
}
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
