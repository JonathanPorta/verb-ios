//
//  SelectableModel.swift
//  Verb
//
//  Created by Jonathan Porta on 8/29/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class SelectableModel {
  var selected: Bool = false

  func select() {
    self.selected = !self.selected
  }
}
