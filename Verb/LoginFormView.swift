//
//  LoginFormView.swift
//  Verb
//
//  Created by Jonathan Porta on 2/5/15.
//  Copyright (c) 2015 Jonathan Porta. All rights reserved.
//

import Foundation

class LoginFormView: UIView {
  let nibTemplateName = "LoginForm"
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

   // Login Form Fields
// @IBOutlet var loginErrorText: UITextView!
// @IBOutlet var loginEmail: UITextField!
// @IBOutlet var loginPassword: UITextField!

}
