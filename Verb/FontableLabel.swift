//
//  FontableLabel.swift
//  Verb
//
//  Created by Jonathan Porta on 11/18/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class FontableLabel: UILabel {

  required init(coder aDecoder: NSCoder) {
    super.init(coder:aDecoder)
    self.setup()
  }

  override init(frame: CGRect) {
    super.init(frame:frame)
    self.setup()
  }

  override func awakeFromNib() {
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

  func hide() {
    super.hidden = true
  }
}
