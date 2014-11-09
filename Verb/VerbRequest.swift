//
//  VerbRequest.swift
//  Verb
//
//  Created by Jonathan Porta on 9/28/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation
import Alamofire

class VerbRequest {

  var hostname: String
  var accessToken: String

  init(hostname: String, accessToken: String) {
    self.hostname = hostname
    self.accessToken = accessToken
    Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["access_token": self.accessToken]
  }

  func get(path: String, parameters: [String: AnyObject]? = nil, delegate: VerbAPIProtocol? = nil){
    let url = "\(self.hostname)\(path)"
    NSLog("Preparing for GET request to: \(url)")

    Alamofire.request(.GET, url, parameters: parameters)
      .responseJSON { (req, res, json, error) in
        if(error != nil) {
          //TODO: Implement API Error Handling Delegate
          NSLog("GET Error: \(error)")
          println(req)
          println(res)
        }
        else {
          NSLog("GET Success: \(url)")
          var json = JSON(json!)
          //TODO: Implement Toggleable Logging
          //NSLog("GET Result: \(json)")

          if (delegate != nil) {
            delegate!.didReceiveResult(json)
          }
        }
      }
  }

  func post(path: String, parameters: [String:AnyObject], delegate: VerbAPIProtocol? = nil){
    let url = "\(self.hostname)\(path)"
    NSLog("Preparing for POST request to: \(url)")

    Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
      .responseJSON { (req, res, json, error) in
        if(error != nil) {
          //TODO: Implement API Error Handling Delegate
          NSLog("POST Error: \(error)")
          println(req)
          println(res)
        }
        else {
          NSLog("POST Success: \(url)")
          var json = JSON(json!)
          //TODO: Implement Toggleable Logging
          //NSLog("POST Result: \(json)")

          if (delegate != nil) {
            delegate!.didReceiveResult(json)
          }
        }
      }
  }
}
