//
//  VerbAPI.swift
//  Verb
//
//  Created by Jonathan Porta on 9/28/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

protocol VerbAPIProtocol {
  func didReceiveAPIResults(results: JSON)
}

class VerbAPI {

  var delegate: VerbAPIProtocol?

  typealias Callback = (JSON) -> ()

  var hostname: String
  var accessToken: String
  var request: Net

  init(hostname: String, accessToken: String) {
    self.hostname = hostname
    self.accessToken = accessToken
    self.request = Net(baseUrlString: self.hostname, headers: ["access_token": self.accessToken])
  }

  func doLogin() -> Void {
    let url = "/auth/facebook_access_token/callback"
    let params = ["access_token": self.accessToken]

    self.request.GET(url, params: params, successHandler: { responseData in
      var json = JSON(data: responseData.data)
      NSLog("Login Result: \(json)")
    }, failureHandler: { error in
      NSLog("Error")
    })
  }

  func getActivities() -> Void {
    self.request.GET("/activities.json", params: nil, successHandler: { responseData in
      var json = JSON(data: responseData.data)
      NSLog("Activities: \(json)")
      self.delegate?.didReceiveAPIResults(json)
      // callback(json)
    }, failureHandler: { error in
      NSLog("Error")
    })
  }

  func acknowledgeMessage(message: MessageModel, callback: Callback) -> Void {
    self.request.GET("/messages/\(message.id)/acknowledge", params: nil, successHandler: { responseData in
      var json = JSON(data: responseData.data)
      NSLog("Acknowledge Message: \(json)")
      callback(json)
    }, failureHandler: { error in
      NSLog("Error")
    })
  }

  func reciprocateMessage(message: MessageModel, callback: Callback) -> Void {
    self.request.GET("/messages/\(message.id)/reciprocate", params: nil, successHandler: { responseData in
      var json = JSON(data: responseData.data)
      NSLog("Reciprocate Message: \(json)")
      callback(json)
      }, failureHandler: { error in
        NSLog("Error")
    })
  }

  func getCategories() -> Void {
    self.request.GET("/verbs", params: nil, successHandler: { responseData in
      var json = JSON(data: responseData.data)
      NSLog("Get Verbs: \(json)")
      self.delegate?.didReceiveAPIResults(json)
    }, failureHandler: { error in
      NSLog("Error")
    })
  }

  func getFriends() -> Void {
    self.request.GET("/friends", params: nil, successHandler: { responseData in
      var json = JSON(data: responseData.data)
      NSLog("Get Friends: \(json)")
      self.delegate?.didReceiveAPIResults(json)
      }, failureHandler: { error in
        NSLog("Error")
    })
  }

  func sendMessage(recipient: UserModel, verb: VerbModel, callback: Callback) -> Void {
    let params = ["message[recipient_id]": recipient.id, "message[verb]": verb.name]
    self.request.POST("/messages.json", params: params, successHandler: { responseData in
      var json = JSON(data: responseData.data)
      NSLog("New Message: \(json)")
      callback(json)
      }, failureHandler: { error in
        NSLog("Error")
    })
  }
}
