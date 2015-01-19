//
//  VerbAPI.swift
//  Verb
//
//  Created by Jonathan Porta on 9/28/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation
import Alamofire

protocol VerbAPIProtocol {
  func didReceiveResult(results: JSON)
}

class VerbAPI {

  class func Login(hostname: String, accessToken: String, closure: (String) -> ()) {
    var url = "\(hostname)/auth/facebook_access_token/callback"
    var params = ["access_token": accessToken]

    VerbRequest.get(url, parameters: params, closure: { (results) -> Void in
      var apiToken = results["api_token"].stringValue

      closure(apiToken)
    })
  }

  class func Register(hostname: String, email: String, password: String, firstName: String, lastName: String, closure: (Int, JSON) -> ()) {
    var url = "\(hostname)/users"
    var params = ["user": [
      "email": email,
      "password": password,
      "first_name": firstName,
      "last_name": lastName
    ]]

    VerbRequest.post(url, parameters: params, closure: { (status: Int, result: JSON) -> Void in
      closure(status, result)
    })
  }

  typealias Callback = (results: JSON) -> ()

  var hostname: String
  var apiToken: String

  init(hostname: String, apiToken: String) {
    self.hostname = hostname
    self.apiToken = apiToken

    Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["api_token": self.apiToken]
  }

  // URL Builder Helper
  func url(path: String) -> String {
    return "\(self.hostname)\(path)"
  }

  func getActivities(delegate: VerbAPIProtocol) {
    var endpoint = url("/activities.json")
    VerbRequest.get(endpoint, delegate: delegate)
  }

  func acknowledgeMessage(message: MessageModel, delegate: VerbAPIProtocol) {
    var endpoint = url("/messages/\(message.id)/acknowledge.json")
    VerbRequest.get(endpoint, delegate: delegate)
  }

  func reciprocateMessage(message: MessageModel, delegate: VerbAPIProtocol) {
    var endpoint = url("/messages/\(message.id)/reciprocate.json")
    VerbRequest.get(endpoint, delegate: delegate)
  }

  func getCategories(delegate: VerbAPIProtocol) {
    var endpoint = url("/verbs.json")
    VerbRequest.get(endpoint, delegate: delegate)
  }

  func getFriends(delegate: VerbAPIProtocol) {
    var endpoint = url("/friends.json")
    VerbRequest.get(endpoint, delegate: delegate)
  }

  func sendMessage(recipient: UserModel, verb: VerbModel, delegate: VerbAPIProtocol) {
    var endpoint = url("/messages.json")
    var params:[String:AnyObject] = ["recipient_id": recipient.id, "verb": verb.verb]

    VerbRequest.post(endpoint, parameters: params, delegate: delegate)
  }

  func registerDevice(token: String) {
    var endpoint = url("/devices.json")
    var params:[String:AnyObject] = ["token": token]

    VerbRequest.post(endpoint, parameters: params)
  }

  func getConnectionFriends(connection: String, delegate: VerbAPIProtocol) {
    var endpoint = url("/friends/\(connection).json")
    VerbRequest.get(endpoint, delegate: delegate)
  }

  func requestFriendship(connectionFriend: ConnectionFriendModel, delegate: VerbAPIProtocol) {
    var endpoint = url("/friendships.json")
    var params:[String:AnyObject] = ["friend_id": connectionFriend.id]

    VerbRequest.post(endpoint, parameters: params, delegate: delegate)
  }

  func acceptFriendship(friendshipModel: FriendshipModel, delegate: VerbAPIProtocol) {
    var endpoint = url("/friendships/\(friendshipModel.id)/accept")
    VerbRequest.get(endpoint, delegate: delegate)
  }
}
