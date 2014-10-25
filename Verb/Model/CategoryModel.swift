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
  var verbs: NSMutableArray

  init(name: String, verbs: NSMutableArray) {
    self.name = name
    self.verbs = verbs
  }
}
