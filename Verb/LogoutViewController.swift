//
//  LogoutViewController.swift
//  Verb
//
//  Created by Jonathan Porta on 8/29/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import UIKit
import Foundation

class LogoutViewController: UIViewController {

  @IBOutlet var logoutButton: UIButton!
  @IBOutlet var cancelButton: UIButton!

  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func logout(sender : AnyObject) {
    println("logout func")
    var activeSession = FBSession.activeSession()
    activeSession.closeAndClearTokenInformation()
    appDelegate.changeStoryBoard("Login")
  }

  @IBAction func cancel(sender : AnyObject) {
    println("cancel func")
    self.view.window!.rootViewController!.dismissViewControllerAnimated(true, completion: nil)
    //self.navigationController.dismissViewControllerAnimated(true, nil)
  }
}