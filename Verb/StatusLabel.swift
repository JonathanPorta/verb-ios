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

class StatusLabel: UILabel {

  let icons: [String]?

  var purple: UIColor?
  var grey: UIColor?

  required init(coder aDecoder: NSCoder) {
    super.init(coder:aDecoder)
    self.setup()
    self.icons = ["e813", "e814", "e815", "e816", "e821", "e823", "e827", "e829", "e82b", "e830", "e831", "e833", "e836", "e838", "e839", "e83a", "e83b", "e841"]
  }

  override init(frame: CGRect) {
    super.init(frame:frame)
    self.setup()
    self.icons = ["e813", "e814", "e815", "e816", "e821", "e823", "e827", "e829", "e82b", "e830", "e831", "e833", "e836", "e838", "e839", "e83a", "e83b", "e841"]
  }

  override  func awakeFromNib() {
    super.awakeFromNib()
    self.setup()
  }
  override class func layerClass() -> AnyClass {
    return CATextLayer.self
  }

  func textLayer() -> CATextLayer {
    return self.layer as CATextLayer
  }

  func setup() {
    self.text = self.text
    self.textColor = self.textColor
    self.font = self.font
    self.textLayer().alignmentMode = kCAAlignmentJustified
    self.textLayer().wrapped = true
    self.layer.display()

    purple = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
    grey = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
  }

  func setActivityModel(activityModel: ActivityModel) {
    setFont(UIFont(name: "icomoon-standard", size: 22.0)!)

    if !activityModel.isPlaceholder() {
      if activityModel.type == "received" {
        setTextColor(purple!)
        if activityModel.isAcknowledged() {
          setText("\u{e73c}")
        }
        else {
          setText("\u{e73b}")
        }
      }
      else {
        setTextColor(grey!)
        if activityModel.isAcknowledged() {
          setText("\u{e73c}")
        }
        else {
          setText("\u{e73b}")
        }
      }
    }
    else {
      setText("")
    }
  }

  func setText(text: String) {
    super.text = text
    self.textLayer().string = text
  }

  func setTextColor(textColor: UIColor) {
    super.textColor = textColor
    self.textLayer().foregroundColor = textColor.CGColor
  }

  func setFont(font: UIFont) {
    super.font = font
    var fontName:CFString = CFStringCreateWithCString(nil, font.fontName, CFStringBuiltInEncodings.UTF8.rawValue)
    var fontRef:CGFontRef = CGFontCreateWithFontName(fontName)
    self.textLayer().font = fontRef
    self.textLayer().fontSize = font.pointSize
  }
}
