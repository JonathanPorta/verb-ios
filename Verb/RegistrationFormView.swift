//
//  RegistrationFormView.swift
//  Verb
//
//  Created by Jonathan Porta on 2/5/15.
//  Copyright (c) 2015 Jonathan Porta. All rights reserved.
//

import Foundation

class RegistrationFormView: UIView {
  //TODO: Figure out a way to set nibTemplateName at init so this class can be for both form types
  let nibTemplateName = "RegistrationForm"
  @IBOutlet var view: UIView!
  var intrinsiceContentSize: CGSize?

  override init() {
    super.init()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    // Load the view from the .xib file
    NSBundle.mainBundle().loadNibNamed(nibTemplateName, owner: self, options: nil)
    // Update the bounds to match the containing view.
    self.bounds = self.view.bounds
    intrinsiceContentSize = self.bounds.size
    // Actually add out .xib based view to, well, our view.
    self.addSubview(self.view)
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    // Load the view from the .xib file
    NSBundle.mainBundle().loadNibNamed(nibTemplateName, owner: self, options: nil)

    // Actually add out .xib based view to, well, our view.
    self.addSubview(self.view)
    intrinsiceContentSize = self.bounds.size
  }

  override func intrinsicContentSize() -> CGSize {
    return intrinsiceContentSize!
  }
// // Register Form Fields
// @IBOutlet var registerErrorText: UITextView!
// @IBOutlet var registerEmail: UITextField!
// @IBOutlet var registerPassword: UITextField!
// @IBOutlet var registerFirstName: UITextField!
// @IBOutlet var registerLastName: UITextField!

}
