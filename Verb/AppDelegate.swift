//
//  AppDelegate.swift
//  Verb
//
//  Created by Jonathan Porta on 8/27/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
  var window: UIWindow?
  var verbAPI: VerbAPI?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
    // Override point for customization after application launch.
    FBLoginView.self
    FBProfilePictureView.self

    var storyBoard : UIStoryboard!
    FBSession.openActiveSessionWithAllowLoginUI(false)
    var activeSession = FBSession.activeSession()

    println("AppDelegate")
    if activeSession.isOpen {
      //Logged in.
      self.getVerbAPI().doLogin()
      println("LOGGED IN!")
      changeStoryBoard("Main")
    }
    else {
      //Not Logged in.
      println("NOT LOGGED IN!")
      changeStoryBoard("Login")
    }
    
    return true
  }

  func getVerbAPI() -> VerbAPI {
    var activeSession = FBSession.activeSession()
    var accessToken = ""
    if activeSession.isOpen {
      accessToken = activeSession.accessTokenData.accessToken
    }
    return VerbAPI(hostname: "http://development.verb.social", accessToken: accessToken)
  }
  
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: NSString?, annotation: AnyObject) -> Bool {
    var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
    return wasHandled
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  func changeStoryBoard(name :String) {
    var storyBoard = UIStoryboard(name:name, bundle: nil)
    var viewController: AnyObject! = storyBoard.instantiateInitialViewController() ;
    self.window!.rootViewController = viewController as? UIViewController
  }
}