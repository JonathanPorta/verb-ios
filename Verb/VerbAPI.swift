//
//  VerbAPI.swift
//  Verb
//
//  Created by Jonathan Porta on 9/28/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

protocol VerbAPIProtocol {
  func didReceiveResult(results: JSON)
}

class VerbAPI {

  typealias Callback = (JSON) -> ()

  var hostname: String
  var accessToken: String
  var verbRequest: VerbRequest

  init(hostname: String, accessToken: String) {
    self.hostname = hostname
    self.accessToken = accessToken
    self.verbRequest = VerbRequest(hostname: hostname, accessToken: accessToken)
  }

  func doLogin(){
    var url = "/auth/facebook_access_token/callback"
    var params = ["access_token": self.accessToken]

    self.verbRequest.get(url, parameters: params)
  }

  func getActivities(delegate: VerbAPIProtocol){
    var url = "/activities.json"
    self.verbRequest.get(url, delegate: delegate)
  }

  func acknowledgeMessage(message: MessageModel, delegate: VerbAPIProtocol){
    var url = "/messages/\(message.id)/acknowledge.json"
    self.verbRequest.get(url, delegate: delegate)
  }

  func reciprocateMessage(message: MessageModel, delegate: VerbAPIProtocol){
    var url = "/messages/\(message.id)/reciprocate.json"
    self.verbRequest.get(url, delegate: delegate)
  }

  func getCategories(delegate: VerbAPIProtocol){
    var url = "/verbs.json"
    self.verbRequest.get(url, delegate: delegate)
  }

  func getFriends(delegate: VerbAPIProtocol){
    var url = "/friends.json"
    self.verbRequest.get(url, delegate: delegate)
  }

  func sendMessage(recipient: UserModel, verb: VerbModel, delegate: VerbAPIProtocol){
    var url = "/messages.json"
    var params:[String:AnyObject] = ["recipient_id": recipient.id, "verb": verb.name]

    self.verbRequest.post(url, parameters: params, delegate: delegate)
  }

  func registerDevice(token: String){
    var url = "/devices.json"
    var params:[String:AnyObject] = ["token": token]

    self.verbRequest.post(url, parameters: params)
  }
}
