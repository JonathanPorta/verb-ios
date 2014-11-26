//
//  VerbModel.swift
//  Verb
//
//  Created by Jonathan Porta on 8/29/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class VerbModel {
  var name: String
  var verb: String
  var icon: String

  init(name: String, verb: String, icon: String) {
    self.name = name
    self.verb = verb
    self.icon = icon
  }

  convenience init(verb: JSON) {
    var name = verb["name"].stringValue
    var v = verb["verb"].stringValue
    var icon = verb["icon"].stringValue

    self.init(name: name, verb: v, icon: icon)
  }
}
