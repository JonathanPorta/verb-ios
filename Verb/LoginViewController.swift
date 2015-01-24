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

  @IBOutlet var registerButton: UIButton!
  @IBOutlet var loginButton: UIButton!
  @IBOutlet var facebookLoginButton: UIButton!

  @IBOutlet var formSwitcher: UISegmentedControl!

  @IBOutlet var formContainer: UIView!
  @IBOutlet var loginForm: UIView!
  @IBOutlet var registerForm: UIView!

  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  let verbPurple = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)

  var segmentControllerBorderViews: Array<UIView> = []

  @IBAction func facebookLogin(button: UIButton) {
    NSLog("LoginViewController::facebookLogin()")
    FBSession.openActiveSessionWithReadPermissions(["public_profile"], allowLoginUI: true, completionHandler: appDelegate.facebookSessionStateChanged)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    self.title = ""
  }

  @IBAction func switchView(control: UISegmentedControl) {
    updateSegmentBorders(control.selectedSegmentIndex)
    if(control.selectedSegmentIndex == 0) {
      // Show Login Form, Hide Register Form
      registerForm.hidden = true
      loginForm.hidden = false
    }
    else if(control.selectedSegmentIndex == 1) {
      // Show Register Form, Hide Login Form
      loginForm.hidden = true
      registerForm.hidden = false
    }
  }

  override func viewWillAppear(animated: Bool) {

    formSwitcher.tintColor = UIColor.clearColor()
    formSwitcher.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState: UIControlState.Selected)
    formSwitcher.setTitleTextAttributes([NSForegroundColorAttributeName: verbPurple], forState: UIControlState.Normal)

    self.title = "\u{e600}"
    var font = UIFont(name: "icomoon-standard", size: 24.0)!

    registerButton.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Normal)
    registerButton.setTitleColor(UIColor.grayColor(), forState:UIControlState.Highlighted)
    registerButton.backgroundColor = verbPurple
    registerButton.layer.masksToBounds = true
    registerButton.layer.cornerRadius = 4.0

    loginButton.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Normal)
    loginButton.setTitleColor(UIColor.grayColor(), forState:UIControlState.Highlighted)
    loginButton.backgroundColor = verbPurple
    loginButton.layer.masksToBounds = true
    loginButton.layer.cornerRadius = 4.0

    // Start off with the Login Form
    loginForm.hidden = false
    registerForm.hidden = true

  }

  func updateSegmentBorders(activeSegment: Int) {
      // We have to manually manage removal of the borders and keep a reference to them.
      for subview in formSwitcher.subviews {
        if(contains(segmentControllerBorderViews, subview as UIView)) {
          subview.removeFromSuperview()
        }
      }
      var controlHeight = formSwitcher.frame.height
      var controlWidth = formSwitcher.frame.width
      var segmentCount = formSwitcher.numberOfSegments
      var segmentWidth = (controlWidth / CGFloat(segmentCount))
      var borderThickness = CGFloat(1)
      var borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
      var originX = 0
      var originY = 0

      for(var i = 0; i < segmentCount; i++) {
        var x = CGFloat(originX) + CGFloat(segmentWidth * CGFloat(i))
        var y = CGFloat(originY)

        if(i == activeSegment) {
          // Set the border of this segment to the active state
          var topBorder = UIView(frame: CGRectMake(x, y, segmentWidth, borderThickness))
          topBorder.backgroundColor = borderColor

          var leftBorder = UIView(frame: CGRectMake(x, y, borderThickness, controlHeight))
          leftBorder.backgroundColor = borderColor

          var rightBorder = UIView(frame: CGRectMake(segmentWidth + x, y, borderThickness, controlHeight))
          rightBorder.backgroundColor = borderColor

          // We need to keep a reference to these so that we can remove them later.
          if(!contains(segmentControllerBorderViews, topBorder)) {
            formSwitcher.addSubview(topBorder)
            segmentControllerBorderViews.insert(topBorder, atIndex: segmentControllerBorderViews.count)
          }

          if(!contains(segmentControllerBorderViews, leftBorder)) {
            formSwitcher.addSubview(leftBorder)
            segmentControllerBorderViews.insert(leftBorder, atIndex: segmentControllerBorderViews.count)
          }

          if(!contains(segmentControllerBorderViews, rightBorder)) {
            formSwitcher.addSubview(rightBorder)
            segmentControllerBorderViews.insert(rightBorder, atIndex: segmentControllerBorderViews.count)
          }
        }
        else {
          // Not the active view, so we add the desired borders.
          var bottomBorder = UIView(frame: CGRectMake(x, y + controlHeight, segmentWidth + borderThickness, borderThickness))
          bottomBorder.backgroundColor = borderColor

          if(!contains(segmentControllerBorderViews, bottomBorder)) {
            formSwitcher.addSubview(bottomBorder)
            segmentControllerBorderViews.insert(bottomBorder, atIndex: segmentControllerBorderViews.count)
          }
        }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // TODO: Like fonts, we need a way to manager the colors and inject them as dependencies.
    self.navigationController?.navigationBar.backgroundColor = verbPurple
    self.navigationController?.navigationBar.barTintColor = verbPurple

    updateSegmentBorders(0)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
    println("LoginController:User Logged In")
    //self.appDelegate.login({
    //  self.appDelegate.changeStoryBoard("Main")
    //})
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
