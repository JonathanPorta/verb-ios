//
//  VerbAPI.swift
//  Verb
//
//  Created by Jonathan Porta on 9/28/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol VerbAPIProtocol {
  func didReceiveResult(results: JSON)
}

class VerbAPI: VerbAPIProtocol {

  typealias Callback = (JSON) -> ()

  var hostname: String
  var accessToken: String
  var verbRequest: VerbRequest

  init(hostname: String, accessToken: String) {
    self.hostname = hostname
    self.accessToken = accessToken
    self.verbRequest = VerbRequest(hostname: hostname, accessToken: accessToken)
  }

  func didReceiveResult(result: JSON){
    NSLog("VerbAPI.onResponse: \(result)")
  }

  func doLogin(){
    var url = "/auth/facebook_access_token/callback"
    var params = ["access_token": self.accessToken]

    self.verbRequest.get(url, parameters: params, delegate: self)
  }

  func getActivities(delegate: VerbAPIProtocol){
    var url = "/activities.json"
    self.verbRequest.get(url, delegate: delegate)
  }

  func acknowledgeMessage(message: MessageModel){
    var url = "/messages/\(message.id)/acknowledge.json"
    self.verbRequest.get(url)
  }

  func reciprocateMessage(message: MessageModel){
    var url = "/messages/\(message.id)/reciprocate.json"
    self.verbRequest.get(url)
  }

  func getCategories(delegate: VerbAPIProtocol){
    var url = "/verbs.json"
    self.verbRequest.get(url, delegate: delegate)
  }

  func getFriends(delegate: VerbAPIProtocol){
    var url = "/friends.json"
    self.verbRequest.get(url, delegate: delegate)
  }

  func sendMessage(recipient: UserModel, verb: VerbModel){
    var url = "/messages.json"
    var params:[String:AnyObject] = ["recipient_id": recipient.id, "verb": verb.name]

    self.verbRequest.post(url, parameters: params)
  }
}
