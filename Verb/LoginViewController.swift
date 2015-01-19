//
//  ViewController.swift
//  Verb
//
//  Created by Jonathan Porta on 8/27/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController, FBLoginViewDelegate {

  @IBOutlet var fbLoginView : FBLoginView!
  @IBOutlet var registerButton: UIButton!
  @IBOutlet var loginButton: UIButton!

  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    self.title = ""
  }

  override func viewWillAppear(animated: Bool) {
    self.title = "\u{e600}"
    var font = UIFont(name: "icomoon-standard", size: 24.0)!
    
    registerButton.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Normal)
    registerButton.setTitleColor(UIColor.grayColor(), forState:UIControlState.Highlighted)
    registerButton.backgroundColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
    registerButton.layer.masksToBounds = true
    registerButton.layer.cornerRadius = 4.0

    loginButton.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Normal)
    loginButton.setTitleColor(UIColor.grayColor(), forState:UIControlState.Highlighted)
    loginButton.backgroundColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
    loginButton.layer.masksToBounds = true
    loginButton.layer.cornerRadius = 4.0
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // TODO: Like fonts, we need a way to manager the colors and inject them as dependencies.
    self.navigationController?.navigationBar.backgroundColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)

    self.fbLoginView.delegate = self
    self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
    println("LoginController:User Logged In")
    self.appDelegate.login({
      self.appDelegate.changeStoryBoard("Main")
    })
  }

  func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
    var userEmail = user.objectForKey("email") as String
    println("User: \(user)")
    println("User ID: \(user.objectID)")
    println("User Name: \(user.name)")
    println("User Email: \(userEmail)")
  }

  func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
    println("User Logged Out")
  }

  func loginView(loginView : FBLoginView!, handleError:NSError) {
    println("Error: \(handleError.localizedDescription)")
  }
}
