//
//  Actionable.swift
//  Verb
//
//  Created by Jonathan Porta on 11/11/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

protocol Actionable: Swipeable {
  var activity: ActivityModel? { get set }
  var type: String { get }
  var createdAtInWords: String { get }

  func isAcknowledged() -> Bool
  func canAcknowledge() -> Bool
  func acknowledge()

  func canReciprocate() -> Bool
  func reciprocate()
}
