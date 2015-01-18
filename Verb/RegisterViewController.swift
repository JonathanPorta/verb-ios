//
//  RegisterViewController.swift
//  Verb
//
//  Created by Jonathan Porta on 1/14/15.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import UIKit
import Foundation

class RegisterViewController: UIViewController, UITextFieldDelegate, VerbAPIProtocol {
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

  @IBOutlet var email: UITextField!
  @IBOutlet var password: UITextField!
  @IBOutlet var firstName: UITextField!
  @IBOutlet var lastName: UITextField!

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
      NSLog(email.text)
      VerbAPI.Register(appDelegate.hostname, email: email.text, password: password.text, firstName: firstName.text, lastName: lastName.text, closure: { (results) -> Void in
        NSLog("Register callback")
        NSLog(results.debugDescription)
      })

    }

    NSLog("textFieldShouldReturn")

    return true
  }

  func didReceiveResult(results: JSON) {
    NSLog("Request returned!")
    NSLog(results.debugDescription)
  }

  override func viewDidLoad() {
      super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
}
