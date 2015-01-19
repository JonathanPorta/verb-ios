//
//  RegisterViewController.swift
//  Verb
//
//  Created by Jonathan Porta on 1/14/15.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import UIKit
import Foundation

class RegisterViewController: UIViewController, UITextFieldDelegate {
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

  @IBOutlet var email: UITextField!
  @IBOutlet var password: UITextField!
  @IBOutlet var firstName: UITextField!
  @IBOutlet var lastName: UITextField!

  @IBOutlet var registerButton: UIButton!

  @IBOutlet var errorText: UITextView!
  @IBOutlet var instructionLabel: UILabel!
  @IBOutlet var registrationForm: UIView!

  override func viewWillAppear(animated: Bool) {
    self.navigationController?.navigationBar.hidden = false

    // Set the button Text Color
    registerButton.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Normal)
    registerButton.setTitleColor(UIColor.grayColor(), forState:UIControlState.Highlighted)
    registerButton.backgroundColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
    registerButton.layer.masksToBounds = true
    registerButton.layer.cornerRadius = 4.0

    email.layer.cornerRadius = 4.0
    password.layer.cornerRadius = 4.0
    firstName.layer.cornerRadius = 4.0
    lastName.layer.cornerRadius = 4.0

    email.layer.masksToBounds = true
    password.layer.masksToBounds = true
    firstName.layer.masksToBounds = true
    lastName.layer.masksToBounds = true

    email.layer.borderWidth = 1.0
    password.layer.borderWidth = 1.0
    firstName.layer.borderWidth = 1.0
    lastName.layer.borderWidth = 1.0

    var greyColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).CGColor
    email.layer.borderColor = greyColor
    password.layer.borderColor = greyColor
    firstName.layer.borderColor = greyColor
    lastName.layer.borderColor = greyColor
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // TODO: Like fonts, we need a way to manager the colors and inject them as dependencies.
    self.navigationController?.navigationBar.backgroundColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
  }

  func textFieldShouldReturn(textField: UITextField!) -> Bool {
    if(textField == email){
      password.becomeFirstResponder()
    }
    else if(textField == password){
      firstName.becomeFirstResponder()
    }
    else if(textField == firstName){
      lastName.becomeFirstResponder()
    }
    else if(textField == lastName){
      textField.resignFirstResponder()
    }
    return true
  }

  @IBAction func submitRegistration() {
    var textfieldsByKey = ["email": self.email, "password": self.password, "first_name": self.firstName, "last_name": self.lastName]
    var textfieldLabelsByKey = ["email": "Email", "password": "Password", "first_name": "First name", "last_name": "Last name"]

    VerbAPI.Register(appDelegate.hostname, email: email.text, password: password.text, firstName: firstName.text, lastName: lastName.text, closure: { (status: Int, result: JSON) -> Void in
      NSLog("Register callback")
      NSLog("Status: \(status)")
      NSLog(result.debugDescription)
      if (status == 422){
        self.errorText.text = "Oops! Something went wrong.\n"
        for (field: String, errors: JSON) in result {
          var errorField = textfieldsByKey[field]
          var errorFieldLabel = textfieldLabelsByKey[field]

          errorField!.layer.borderColor = UIColor.redColor().CGColor
          self.errorText.text = "\(self.errorText.text)\n\(errorFieldLabel!) \(errors[0].stringValue)"
        }
        self.errorText.hidden = false
        self.errorText.font = UIFont(name: "Helvetica", size: 17)
        self.errorText.textAlignment = NSTextAlignment.Center
      }
    })
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
