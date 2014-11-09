//
//  Model.swift
//  Verb
//
//  Created by Jonathan Porta on 8/27/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class Model {

  var endpoint: String

  init(endpoint: String) {
    self.endpoint = endpoint
  }

  func didReceiveResult(result: JSON) { }

}
