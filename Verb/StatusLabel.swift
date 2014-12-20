//
//  StatusLabel.swift
//  Verb
//
//  Created by Jonathan Porta on 11/18/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class StatusLabel: FontableLabel {

  let purple = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
  let grey = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)

  func setActivityModel(activityModel: ActivityModel) {
    super.setFont(UIFont(name: "icomoon-standard", size: 22.0)!)

    if !activityModel.isPlaceholder() {
      if activityModel.type == "received" {
        super.setTextColor(purple)
        if activityModel.isAcknowledged() {
          super.setText("\u{e73c}")
        }
        else {
          super.setText("\u{e73b}")
        }
      }
      else {
        super.setTextColor(grey)
        if activityModel.isAcknowledged() {
          super.setText("\u{e73c}")
        }
        else {
          super.setText("\u{e73b}")
        }
      }
    }
    else {
      super.setText("")
    }
  }
}
