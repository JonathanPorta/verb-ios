//
//  CategoryModel.swift
//  Verb
//
//  Created by Jonathan Porta on 8/29/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class CategoryModel {
  var name: String
  var icon: String
  var verbs: NSMutableArray

  init(name: String, icon: String, verbs: NSMutableArray) {
    self.name = name
    self.icon = icon
    self.verbs = verbs
  }

  convenience init(category: JSON) {
    var name = category["name"].stringValue
    var icon = category["icon"].stringValue

    var verbs: NSMutableArray = []
    for (index: String, verb: JSON) in category["verbs"] {
      verbs.addObject(VerbModel(verb: verb))
    }
    self.init(name: name, icon: icon, verbs: verbs)
  }
}
