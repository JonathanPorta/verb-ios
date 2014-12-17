//
//  Swipeable.swift
//  Verb
//
//  Created by Jonathan Porta on 11/11/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

protocol Swipeable {
  func promptMessage() -> String
  func workingMessage() -> String
  func isSwipeable() -> Bool
}
