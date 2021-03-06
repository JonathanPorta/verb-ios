//
//  RegistrationFormView.swift
//  Verb
//
//  Created by Jonathan Porta on 2/5/15.
//  Copyright (c) 2015 Jonathan Porta. All rights reserved.
//

import Foundation

class RegistrationFormView: UIView {
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  let verbPurple = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)

  @IBOutlet var view: UIView!

  @IBOutlet var emailField: UITextField!
  @IBOutlet var passwordField: UITextField!
  @IBOutlet var firstNameField: UITextField!
  @IBOutlet var lastNameField: UITextField!

  @IBOutlet var submitButton: UIButton!

  @IBOutlet var messageTextView: UITextView!

  //TODO: Figure out a way to set nibTemplateName at init so this class can be for both form types
  let nibTemplateName = "RegistrationForm"
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

  @IBAction func submit() {
    println("submit button tapped!")

    var textfieldsByKey = ["email": self.emailField, "password": self.passwordField, "first_name": self.firstNameField, "last_name": self.lastNameField]
    var textfieldLabelsByKey = ["email": "Email", "password": "Password", "first_name": "First name", "last_name": "Last name"]

    VerbAPI.Register(appDelegate.hostname, email: emailField.text, password: passwordField.text, firstName: firstNameField.text, lastName: lastNameField.text, closure: { (status: Int, result: JSON) -> Void in
      NSLog("Register callback")
      NSLog("Status: \(status)")
      NSLog(result.debugDescription)
      if (status == 422){
        self.messageTextView.text = "Oops! Something went wrong.\n"
        for (field: String, errors: JSON) in result {
          var errorField = textfieldsByKey[field]
          var errorFieldLabel = textfieldLabelsByKey[field]

          errorField!.layer.borderColor = UIColor.redColor().CGColor
          self.messageTextView.text = "\(self.messageTextView.text)\n\(errorFieldLabel!) \(errors[0].stringValue)"
        }
        self.messageTextView.hidden = false
        self.messageTextView.font = UIFont(name: "Helvetica", size: 17)
        self.messageTextView.textAlignment = NSTextAlignment.Center
      }
    })

  }
// // Register Form Fields
// @IBOutlet var registerErrorText: UITextView!
// @IBOutlet var registerEmail: UITextField!
// @IBOutlet var registerPassword: UITextField!
// @IBOutlet var registerFirstName: UITextField!
// @IBOutlet var registerLastName: UITextField!

}
