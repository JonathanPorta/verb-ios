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
        var json = JSON(json!)
        NSLog("GET Result: \(json)")
        NSLog("GET Error: \(error)")

        if (delegate != nil) {
          delegate!.didReceiveResult(json)
        }
      }
  }

  func post(path: String, parameters: [String:AnyObject], delegate: VerbAPIProtocol? = nil){
    let url = "\(self.hostname)\(path)"
    NSLog("Preparing for POST request to: \(url)")

    Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
      .responseJSON { (req, res, json, error) in
        var json = JSON(json!)
        NSLog("POST Result: \(json)")
        NSLog("POST Error: \(error)")

        if (delegate != nil) {
          delegate!.didReceiveResult(json)
        }
      }
  }
}
